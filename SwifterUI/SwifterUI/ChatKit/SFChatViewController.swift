//
//  SFChatViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import MobileCoreServices

open class SFChatViewController<MessageType: SFMessage>: SFViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFVideoPlayerDelegate {

    // MARK: - Instance Properties

    private var activeCell: SFTableViewChatCell?
    
    public let chatManager = SFTableManager<MessageType, SFTableViewChatCell, SFTableViewHeaderView, SFTableViewFooterView>(data: [])

    public final lazy var chatView: SFTableView = {
        let tableView = SFTableView(automaticallyAdjustsColorStyle: true, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.useAlternativeColors = true
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
    private var cachedBubbleWidths: [IndexPath: CGFloat] = [:]

    // MARK: - Initializers

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Instance Methods

    override open func viewDidLoad() {
        if let view = view as? SFView {
            view.useAlternativeColors = true
        }
        super.viewDidLoad()
        view.addSubview(chatView)
        chatManager.configure(tableView: chatView) { (cell, message, index) in
            self.configure(cell: cell, message: message, indexPath: index)
        }
        chatView.delegate = self
        chatBar.sendButton.addTarget(self, action: #selector(sendButtonDidTouch), for: .touchUpInside)
        chatBar.fileButton.addTarget(self, action: #selector(mediaButtonDidTouch), for: .touchUpInside)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        autorotate = false
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        chatView.clipEdges()
    }
    
    override open func viewDidLayoutSubviews() {
        cachedHeights.removeAll()
        cachedBubbleWidths.removeAll()
        super.viewDidLayoutSubviews()
        chatView.scrollToBottom(animated: false)
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
            if chatView.isDragging == false {
                chatView.scrollToBottom(animated: true)
            }
        }
    }
    
    func configure(cell: SFTableViewChatCell, message: MessageType, indexPath: IndexPath) {
        cell.delegate = self
        cell.messageLabel.text = message.text
        cell.messageImageView.image = message.image
        cell.messageVideoView.url = message.videoURL
        cell.messageVideoView.delegate = self
        cell.isUserInteractionEnabled = true
        
        if let width = cachedBubbleWidths[indexPath] {
            cell.width = width
        } else {
            if message.image != nil || message.videoURL != nil || message.imageURL != nil {
                cell.width = (chatView.bounds.width * 2/3)
            } else {
                cell.width = message.text?.estimatedFrame(with: cell.messageLabel.font, maxWidth: (chatView.bounds.width * 2/3) - 16).size.width ?? 0
            }
        }
        
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
        photosButton.add {
            self.showMediaPicker(sourceType: .photoLibrary)
        }
        
        let cameraButton = SFButton()
        cameraButton.setTitle("Camara", for: .normal)
        cameraButton.add {
            self.showMediaPicker(sourceType: .camera)
        }
        
        let viewController = SFBulletinController(buttons: [photosButton, cameraButton])
        viewController.bulletinTitle = "Multimedia"
        present(viewController, animated: true, completion: nil)
    }

    private final func showMediaPicker(sourceType: UIImagePickerControllerSourceType) {
        DispatchQueue.addAsyncTask(to: .background) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            
            DispatchQueue.addAsyncTask(to: .main, handler: {
                self.present(imagePicker, animated: true, completion: nil)
            })
        }
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
                chatManager.insert(item: message, animation: message.isMine ? .right : .left).done {
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
                self.chatManager.insert(item: message, animation: message.isMine ? .right : .left).done {
                    self.chatView.scrollToBottom()
                }
            }
        })
    }

    // MARK: - UITableViewDelegate

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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

extension SFChatViewController: SFTableViewChatCellDelegate {

    // MARK: - Instance Methods

    public func didZoomIn(cell: SFTableViewChatCell) {
        guard let image = cell.messageImageView.image else { return }
        let controller = SFNavigationController(rootViewController: SFImageZoomViewController(with: image))
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true) {
            UIView.animate(.promise, duration: 0.1, animations: {
                cell.messageImageView.alpha = 0
            }).done({ _ in
                cell.zoomOut()
            })
        }
    }

    public func didZoomOut(cell: SFTableViewChatCell) {
        UIView.animate(withDuration: 0.3, animations: {
            cell.messageImageView.alpha = 1
        }) { (finished) in
        }
    }
}











