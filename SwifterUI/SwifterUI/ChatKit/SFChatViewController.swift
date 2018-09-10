//
//  SFChatViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import MobileCoreServices

open class SFChatViewController: SFViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFVideoPlayerDelegate, SFTableViewChatCellDelegate {
    
    // MARK: - Instance Properties
    
    private var activeCell: SFTableViewChatCell?
    
    public lazy var chatManager: SFTableManager<SFMessage, SFTableViewChatCell, SFTableViewHeaderView, SFTableViewFooterView> = {
        let chatManager = SFTableManager<SFMessage, SFTableViewChatCell, SFTableViewHeaderView, SFTableViewFooterView>()
        
        chatManager.delegate = self
        
        chatManager.configure(tableView: chatView) { [unowned self] (cell, message, indexPath) in
            
            cell.delegate = self
            cell.messageLabel.text = message.text
            
            if let image = message.image {
                cell.messageImageView.image = image
            } else if let string = message.imageURL, let url = URL(string: string) {
                cell.messageImageView.kf.setImage(with: url)
            }
            
            if let string = message.videoURL, let url = URL(string: string) {
                cell.messageVideoView.url = url
            }
            
            cell.messageVideoView.delegate = self
            cell.isUserInteractionEnabled = true
            
            if self.cachedWidths[indexPath] == nil {
                self.calculateWidth(for: message, indexPath: indexPath)
            }
            
            cell.width = self.cachedWidths[indexPath] ?? 0
            
            if message.senderIdentifier == self.chat.currentUser.identifier {
                cell.bubbleView.useAlternativeColors = true
                cell.isMine = true
                cell.updateColors()
            } else {
                cell.bubbleView.useAlternativeColors = false
                cell.isMine = false
                cell.updateColors()
            }
            
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
        
        return chatManager
    }()
    
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
        chatBar.textView.delegate = self
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
        zoomImageView.clipsToBounds = true
        return zoomImageView
    }()
    
    private weak var currentZoomCell: SFTableViewChatCell?
    private lazy var initialFrameForZooming: CGRect = .zero
    
    public var numberOfMessages: Int {
        var numberOfMessages = 0
        chatManager.data.forEach({ numberOfMessages += $0.content.count })
        return numberOfMessages
    }
    
    var chat: SFChat
    
    // MARK: - Initializers
    
    init(chat: SFChat, automaticallyAdjustsColorStyle: Bool = true) {
        self.chat = chat
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        chatManager.update(dataSections: chat.messages.ordered())
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
        
        chatBar.sendButton.addAction { [unowned self] in self.sendButtonDidTouch() }
        
        chatBar.fileButton.addAction { [unowned self] in self.mediaButtonDidTouch() }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessages), name: Notification.Name(SFChatNotification.multipleMessagesUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedMessage(notification:)), name: Notification.Name(SFChatNotification.newMessageUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cachedWidths.removeAll()
        cachedHeights.removeAll()
        super.viewWillTransition(to: size, with: coordinator)
        chatView.reloadData()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chatView.clipSides()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isWaitingForPopViewController { self.chatView.scrollToBottom(animated: false) }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        markMessagesAsRead()
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
            chatView.contentInset.bottom = keyboardHeight - view.safeAreaInsets.bottom
            chatView.scrollIndicatorInsets.bottom = chatView.contentInset.bottom
            
            if chatView.isDragging == false && chatView.contentOffset.y > -64 {
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
    
    func calculateWidth(for message: SFMessage, indexPath: IndexPath) {
        if message.image != nil || message.videoURL != nil || message.imageURL != nil {
            self.cachedWidths[indexPath] = (self.chatView.bounds.width * 2/3)
        } else {
            self.cachedWidths[indexPath] = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 17), maxWidth: (self.chatView.bounds.width * 2/3) - 16).size.width ?? 0
        }
    }
    
    open func markMessagesAsRead() {
        chat.messages.forEach { (message) in
            if !message.read && message.senderIdentifier != chat.currentUser.identifier {
                message.read = true
            }
        }

        chat.unreadMessages = 0
        NotificationCenter.default.post(name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil, userInfo: ["SFChat": chat])
    }
    
    @objc open func updateMessages() {
        chatManager.updateSections(dataSections: chat.messages.ordered())
        markMessagesAsRead()
    }
    
    @objc open func receivedMessage(notification: Notification) {
        if let notificationChat = notification.userInfo?["SFChat"] as? SFChat, notificationChat.identifier == chat.identifier, let message = chat.messages.last {
            addNewMessage(message)
            markMessagesAsRead()
        }
    }
    
    // MARK: - Media Methods
    
    private final func mediaButtonDidTouch() {
        let photosButton = SFFluidButton()
        photosButton.title = "Fotos y Videos"
        photosButton.addAction {
            self.showMediaPicker(sourceType: .photoLibrary)
        }
        
        let cameraButton = SFFluidButton()
        cameraButton.title = "Camara"
        cameraButton.addAction { [unowned self] in
            self.showMediaPicker(sourceType: .camera)
        }
        
        let viewController = SFBulletinViewController(title: "Multimedia", buttons: [photosButton, cameraButton])
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Send Methods
    
    open func send(message: SFMessage) -> Bool {
        return true
    }
    
    private final func sendButtonDidTouch() {
        if chatBar.textView.text != "" {
            let message = SFMessage(senderIdentifier: chat.currentUser.identifier, text: chatBar.textView.text, imageURL: nil, image: nil, videoURL: nil, fileURL: nil, creationDate: Date(), read: false, chatIdentifier: chat.identifier)
            if send(message: message) {
                chatBar.textView.text = ""
                chat.messages.append(message)
            }
        }
    }
    
    public func addNewMessage(_ message: SFMessage) {
        chat.modificationDate = Date()
        let messageDate = message.creationDate.string(with: "EEEE dd MMM yyyy")
        if let lastSection = chatManager.data.last {
            if lastSection.identifier != messageDate {
                let section = SFDataSection<SFMessage>(content: [message], identifier: messageDate)
                chatManager.insertSection(section, index: chatManager.lastItemIndex.section + 1, animation: message.senderIdentifier == chat.currentUser.identifier ? .right : .left).done {
                    self.chatView.scrollToBottom()
                }
            } else {
                chatManager.insertItem(message, animation: message.senderIdentifier == chat.currentUser.identifier ? .right : .left).done {
                    self.chatView.scrollToBottom()
                }
            }
        } else {
            let section = SFDataSection<SFMessage>(content: [message], identifier: messageDate)
            chatManager.insertSection(section, animation: message.senderIdentifier == chat.currentUser.identifier ? .right : .left).done {
                self.chatView.scrollToBottom()
            }.catch { (error) in
                self.showError(title: "Error desconocido", message: error.localizedDescription)
            }
        }
    }
    
    public func addNewMessages(_ newMessages: [SFMessage]) {
        newMessages.forEach({ addNewMessage($0) })
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    open func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [String: Any]) {
        
        var optionalMessage: SFMessage? = nil
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            optionalMessage = SFMessage(senderIdentifier: chat.currentUser.identifier, text: nil, imageURL: nil, image: originalImage, videoURL: nil, fileURL: nil, creationDate: Date(), read: false, chatIdentifier: chat.identifier)
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            optionalMessage = SFMessage(senderIdentifier: chat.currentUser.identifier, text: nil, imageURL: nil, image: nil, videoURL: videoURL.absoluteString, fileURL: nil, creationDate: Date(), read: false, chatIdentifier: chat.identifier)
        }
        
        picker.dismiss(animated: true, completion: {
            guard let message = optionalMessage else { return }
            if self.send(message: message) {
                self.chat.messages.append(message)
            }
        })
    }
    
    // MARK: - SFTableViewChatCellDelegate
    
    open func didSelectImageView(cell: SFTableViewChatCell) {
        guard let image = cell.messageImageView.image else { return }
        isWaitingForPopViewController = true
        zoomImageView.image = image
        initialFrameForZooming = view.convert(cell.bubbleView.bounds, from: cell.messageImageView)
        print(initialFrameForZooming)
        zoomImageView.frame = initialFrameForZooming
        view.addSubview(zoomImageView)
        cell.bubbleView.alpha = 0.0
        currentZoomCell = cell
        UIView.animate(withDuration: 0.3, animations: {
            self.zoomImageView.frame = self.view.bounds
            self.zoomImageView.layer.cornerRadius = 0
        }) { [unowned self] (_) in
            let zoomViewController = SFImageZoomViewController(with: image)
            self.navigationController?.pushViewController(zoomViewController, animated: true)
        }
    }
    
    private func zoomOut() {
        self.zoomImageView.contentMode = .scaleAspectFill
        UIView.animate(withDuration: 0.3, animations: {
            self.zoomImageView.frame = self.initialFrameForZooming
            self.zoomImageView.layer.cornerRadius = 10
        }) { (_) in
            self.currentZoomCell?.bubbleView.alpha = 1.0
            self.zoomImageView.removeFromSuperview()
            self.zoomImageView.contentMode = .scaleAspectFit
        }
    }
    
}

extension SFChatViewController: SFTableManagerDelegate {
    public func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat? {
        
        guard let height = cachedHeights[indexPath] else {
            
            let message = chatManager.getItem(at: indexPath)
            
            if let image = message.image {
                let height = ((view.bounds.width * 2/3) / (image.size.width / image.size.height)) + 33
                cachedHeights[indexPath] = height
                return height
            } else if message.imageURL != nil {
                return view.bounds.width * 2/3
            } else if message.videoURL != nil {
                let height = view.bounds.width * 2/3
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

extension SFChatViewController: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        chatBar.sendButton.getConstraint(.right)?.constant = -8
        
        let animator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
        
        animator.addAnimations {
            self.chatBar.layoutIfNeeded()
        }
        
        animator.addAnimations({
            self.chatBar.sendButton.alpha = 1.0
        }, delayFactor: 0.1)
        
        animator.startAnimation()
        
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        chatBar.sendButton.getConstraint(.right)?.constant = 28
        
        let animator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
        
        animator.addAnimations {
            self.chatBar.sendButton.alpha = 0.0
        }
        
        animator.addAnimations({
            self.chatBar.layoutIfNeeded()
        }, delayFactor: 0.1)
        
        animator.startAnimation()
        
    }
    
}









