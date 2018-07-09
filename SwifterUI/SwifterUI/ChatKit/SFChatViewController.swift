//
//  SFChatViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import MobileCoreServices

open class SFChatViewController<MessageType: SFMessage>: SFViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFVideoPlayerDelegate, SFTableViewChatCellDelegate {
    
    // MARK: - Static Methods
    
    static open func orderMessages(_ messages: [MessageType]) -> [SFDataSection<MessageType>] {
        var sections: [SFDataSection<MessageType>] = []
        
        for message in messages {
            
            if let index = sections.index(where: { $0.identifier == message.timestamp.string(with: "EEEE dd MMM yyyy") }) {
                sections[index].content.append(message)
            } else {
                let section = SFDataSection<MessageType>(content: [message], identifier: message.timestamp.string(with: "EEEE dd MMM yyyy"))
                sections.append(section)
            }
        }
        
        sections = sections.sorted(by: { (current, next) -> Bool in
            guard let currentDate = Date.date(from: current.identifier, with: "EEEE dd MMM yyyy") else { return false }
            guard let nextDate = Date.date(from: next.identifier, with: "EEEE dd MMM yyyy") else { return false }
            return currentDate < nextDate
        })
        
        return sections
    }
    
    // MARK: - Instance Properties
    
    private var activeCell: SFTableViewChatCell?
    
    public var chatManager: SFTableManager<MessageType, SFTableViewChatCell, SFTableViewHeaderView, SFTableViewFooterView>
    
    public var messages: [MessageType] = []
    
    public final lazy var chatView: SFTableView = {
        let tableView = SFTableView(automaticallyAdjustsColorStyle: true, useAlternativeColors: true, style: .grouped)
        tableView.useAlternativeColors = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    public final lazy var chatBar: SFChatBar = {
        let chatBar = SFChatBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        chatBar.translatesAutoresizingMaskIntoConstraints = false
        return chatBar
    }()
    
    private lazy var filesButton: SFButton = {
        let filesButton = SFButton()
        filesButton.setTitle("Archivos", for: .normal)
        return filesButton
    }()
    
    open override var inputAccessoryView: UIView? {
        return chatBar
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private var cachedHeights: [IndexPath: CGFloat] = [:]
    private var cachedWidths: [IndexPath: CGFloat] = [:]
    
    private var isWaitingForPopViewController: Bool = false
    
    private lazy var zoomImageView: UIImageView = {
        let zoomImageView = UIImageView()
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.layer.cornerRadius = 10
        return zoomImageView
    }()
    
    private weak var currentZoomCell: SFTableViewChatCell?
    private lazy var initialFrameForZooming: CGRect = .zero
    
    // MARK: - Initializers
    
    public init(messages: [MessageType], automaticallyAdjustsColorStyle: Bool) {
        chatManager = SFTableManager<MessageType, SFTableViewChatCell, SFTableViewHeaderView, SFTableViewFooterView>(dataSections: SFChatViewController.orderMessages(messages))
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        chatManager.delegate = self
        self.messages = messages
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(chatView)
        
        chatBar.sendButton.addTarget(self, action: #selector(sendButtonDidTouch), for: .touchUpInside)
        chatBar.fileButton.addTarget(self, action: #selector(mediaButtonDidTouch), for: .touchUpInside)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        
        chatManager.configure(tableView: chatView) { [unowned self] (cell, message, index) in
            self.configure(cell: cell, message: message, indexPath: index)
        }
        
        chatManager.prefetchStyler = { [unowned self] (message, index) in
            self.calculateWidth(for: message, indexPath: index)
        }
        
        chatManager.headerStyler = {  (view, section, index) in
            view.titleLabel.text = section.identifier
            view.titleLabel.textAlignment = .center
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
            view.titleLabel.useAlternativeColors = false
            view.useAlternativeColors = true
        }
        
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cachedWidths.removeAll()
        cachedHeights.removeAll()
        super.viewWillTransition(to: size, with: coordinator)
        chatView.reloadData()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chatView.clipEdges()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isWaitingForPopViewController { self.chatView.scrollToBottom(animated: false) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    open override func updateColors() {
        super.updateColors()
        if let view = inputAccessoryView as? SFViewColorStyle {
            view.updateColors()
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            chatView.contentInset.bottom = keyboardHeight
            chatView.scrollIndicatorInsets.bottom = keyboardHeight
            
            if chatView.isDragging == false && chatView.contentOffset.y != -64 {
                if !isWaitingForPopViewController {
                    self.chatView.scrollToBottom(animated: false)
                } else {
                    if zoomImageView.superview != nil {
                        zoomOut()
                    }
                }
            }
        }
    }
    
    func calculateWidth(for message: MessageType, indexPath: IndexPath) {
        if message.image != nil || message.videoURL != nil || message.imageURL != nil {
            self.cachedWidths[indexPath] = (self.chatView.bounds.width * 2/3)
        } else {
            self.cachedWidths[indexPath] = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 17), maxWidth: (self.chatView.bounds.width * 2/3) - 16).size.width ?? 0
        }
    }
    
    func configure(cell: SFTableViewChatCell, message: MessageType, indexPath: IndexPath) {
        cell.delegate = self
        cell.messageLabel.text = message.text
        cell.messageImageView.image = message.image
        cell.messageVideoView.url = message.videoURL
        cell.messageVideoView.delegate = self
        cell.isUserInteractionEnabled = true
        
        if cachedWidths[indexPath] == nil {
            calculateWidth(for: message, indexPath: indexPath)
        }
        
        cell.width = cachedWidths[indexPath] ?? 0
        
        if message.isMine {
            cell.bubbleView.useAlternativeColors = true
            cell.isMine = true
            cell.updateColors()
        } else {
            cell.bubbleView.useAlternativeColors = false
            cell.isMine = false
            cell.updateColors()
        }
        
    }
    
    // MARK: - Media Methods
    
    @objc private final func mediaButtonDidTouch() {
        
        let photosButton = SFButton()
        photosButton.setTitle("Fotos y Videos", for: .normal)
        photosButton.addTouchAction {
            self.showMediaPicker(sourceType: .photoLibrary)
        }
        
        let cameraButton = SFButton()
        cameraButton.title = "Camara"
        cameraButton.addTouchAction { [unowned self] in
            self.showMediaPicker(sourceType: .camera)
        }
        
        let viewController = SFBulletinController(buttons: [photosButton, cameraButton])
        viewController.bulletinTitle = "Multimedia"
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Send Methods
    
    open func send(message: MessageType) -> Bool {
        return true
    }
    
    @objc private final func sendButtonDidTouch() {
        if chatBar.textView.text != "" {
            let message = MessageType(senderIdentifier: "",
                                      text: chatBar.textView.text,
                                      image: nil, videoURL: nil,
                                      fileURL: nil,
                                      timestamp: Date(),
                                      isMine: true)
            
            if send(message: message) {
                chatBar.textView.text = ""
                addNewMessages([message])
            }
        }
    }
    
    public func addNewMessages(_ newMessages: [MessageType]) {
        for message in newMessages {
            if let lastMessage = messages.last {
                if lastMessage.timestamp.string(with: "EEEE dd MMM yyyy") != message.timestamp.string(with: "EEEE dd MMM yyyy") {
                    messages.append(message)
                    chatManager.update(dataSections: SFChatViewController.orderMessages(messages), animation: .fade).done {
                        self.chatView.scrollToBottom()
                    }
                } else {
                    messages.append(message)
                    chatManager.insert(item: message, animation: message.isMine ? .right : .left).done {
                        self.chatView.scrollToBottom()
                    }
                }
            } else {
                messages.append(message)
                chatManager.update(dataSections: SFChatViewController.orderMessages(messages), animation: .fade).done {
                    self.chatView.scrollToBottom()
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    open func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [String: Any]) {
        
        var optionalMessage: MessageType? = nil
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            optionalMessage = MessageType(senderIdentifier: "",
                                          text: nil,
                                          image: originalImage,
                                          videoURL: nil,
                                          fileURL: nil,
                                          timestamp: Date(),
                                          isMine: true)
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            optionalMessage = MessageType(senderIdentifier: "",
                                          text: nil,
                                          image: nil,
                                          videoURL: videoURL,
                                          fileURL: nil,
                                          timestamp: Date(),
                                          isMine: true)
        }
        
        picker.dismiss(animated: true, completion: {
            guard let message = optionalMessage else { return }
            if self.send(message: message) {
                self.addNewMessages([message])
            }
        })
    }
    
    // MARK: - SFTableViewChatCellDelegate
    
    open func didSelectImageView(cell: SFTableViewChatCell) {
        guard let image = cell.messageImageView.image else { return }
        isWaitingForPopViewController = true
        zoomImageView.image = image
        initialFrameForZooming = view.convert(cell.bubbleView.bounds, from: cell.messageImageView)
        zoomImageView.frame = initialFrameForZooming
        view.addSubview(zoomImageView)
        cell.bubbleView.alpha = 0.0
        currentZoomCell = cell
        UIView.animate(withDuration: 0.3, animations: {
            self.zoomImageView.frame = self.view.bounds
        }) { [unowned self] (_) in
            let zoomViewController = SFImageZoomViewController(with: image)
            self.navigationController?.pushViewController(zoomViewController, animated: true)
        }
    }
    
    private func zoomOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.zoomImageView.frame = self.initialFrameForZooming
        }) { (_) in
            self.currentZoomCell?.bubbleView.alpha = 1.0
            self.zoomImageView.removeFromSuperview()
        }
    }
    
}

extension SFChatViewController: SFTableManagerDelegate {
    public func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat? {
        
        guard let height = cachedHeights[indexPath] else {
            
            let message = chatManager.getItem(at: indexPath)
            
            if let image = message.image {
                let height = ((tableView.bounds.width * 2/3) / (image.size.width / image.size.height)) + 33
                cachedHeights[indexPath] = height
                return height
            } else if message.imageURL != nil {
                return tableView.bounds.width * 2/3
            } else if message.videoURL != nil {
                let height = tableView.bounds.width * 2/3
                cachedHeights[indexPath] = height
                return height
            } else {
                guard let size = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 17),
                                                              maxWidth: (self.view.bounds.width * 2/3) - 16)
                    else { return 0 }
                let height = size.height + 33
                cachedHeights[indexPath] = height
                return height
            }
            
        }
        return height
    }
}










