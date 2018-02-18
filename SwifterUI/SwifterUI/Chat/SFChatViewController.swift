//
//  SFChatViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import MobileCoreServices

open class SFChatViewController<MessageType: SFMessage>: SFViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFVideoPlayerDelegate {
    
    // MARK: - Instance Properties
    
    private var activeCell: SFTableViewChatCell? = nil
    
    open var chatView: SFChatView {
        return self.view as! SFChatView
    }
    
    open lazy var chatBar: SFChatBar = {
        let chatBar = SFChatBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
        return chatBar
    }()
    
    open override var inputAccessoryView: UIView? {
        get {
            return chatBar
        }
    }
    
    open override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    private lazy var photosButton: SFButton = {
        let photosButton = SFButton()
        photosButton.setTitle("Fotos y Videos", for: .normal)
        return photosButton
    }()
    
    private lazy var cameraButton: SFButton = {
        let photosButton = SFButton()
        photosButton.setTitle("Camara", for: .normal)
        return photosButton
    }()
    
    private lazy var filesButton: SFButton = {
        let filesButton = SFButton()
        filesButton.setTitle("Archivos", for: .normal)
        return filesButton
    }()
    
    open var messages: [MessageType] = []
    private var cachedHeights: [IndexPath: CGFloat] = [:]
    private var cachedBubbleWidths: [IndexPath: CGFloat] = [:]
    
    // MARK: - Initializers
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    open override func loadView() {
        self.view = SFChatView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, frame: .zero)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
        chatBar.sendButton.addTarget(self, action: #selector(sendButtonDidTouch), for: .touchUpInside)
        chatBar.fileButton.addTarget(self, action: #selector(mediaButtonDidTouch), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        autorotate = false
    }
    
    override open func viewDidLayoutSubviews() {
        cachedHeights.removeAll()
        cachedBubbleWidths.removeAll()
        super.viewDidLayoutSubviews()
        chatView.tableView.scrollToBottom(animated: false)
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
            chatView.tableView.contentInset.bottom = keyboardHeight
            chatView.tableView.scrollIndicatorInsets.bottom = keyboardHeight
            if chatView.tableView.isDragging == false {
                chatView.tableView.scrollToBottom(animated: true)
            }
        }
    }
    
    // MARK: - Media Methods
    
    @objc private func mediaButtonDidTouch() {
        let viewController = SFPickerController(buttons: [photosButton, cameraButton])
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.pickerTitle = "Multimedia"
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    private func showMediaPicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
        
    // MARK: - Send Methods
    
    @objc private func sendButtonDidTouch() {
        if self.chatBar.textView.text != "" {
            let message = MessageType(text: self.chatBar.textView.text, image: nil, videoURL: nil, fileURL: nil, isMine: true, timestamp: Date())
            messages.append(message)
            self.chatBar.textView.text = ""
            let numberOfSection = chatView.tableView.numberOfSections - 1 > 0 ? chatView.tableView.numberOfSections - 1 : 0
            let rowNumber = chatView.tableView.numberOfRows(inSection: numberOfSection)
            didSend(message: message)
            chatView.tableView.beginUpdates()
            chatView.tableView.insertRows(at: [IndexPath(row: rowNumber, section: numberOfSection)], with: .fade)
            chatView.tableView.endUpdates()
            chatView.tableView.scrollToBottom(animated: true)
        }
    }
    
    open func didSend(message: MessageType) {
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var optionalMessage: MessageType? = nil
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            optionalMessage = MessageType(text: "Envió una imagen", image: originalImage, videoURL: nil, fileURL: nil, isMine: true, timestamp: Date())
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            optionalMessage = MessageType(text: "Envió un video", image: nil, videoURL: videoURL, fileURL: nil, isMine: true, timestamp: Date())
        }
        
        picker.dismiss(animated: true, completion: {
            guard let message = optionalMessage else { return }
            self.messages.append(message)
            let numberOfSection = self.chatView.tableView.numberOfSections - 1 > 0 ? self.chatView.tableView.numberOfSections - 1 : 0
            let rowNumber = self.chatView.tableView.numberOfRows(inSection: numberOfSection)
            self.didSend(message: message)
            self.chatView.tableView.beginUpdates()
            self.chatView.tableView.insertRows(at: [IndexPath(row: rowNumber, section: numberOfSection)], with: .fade)
            self.chatView.tableView.endUpdates()
            self.chatView.tableView.scrollToBottom(animated: true)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SFTableViewChatCell else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.messageImageView.image = message.image
        cell.messageVideoView.url = message.videoURL
        cell.isUserInteractionEnabled = true
        cell.messageVideoView.delegate = self
        cell.delegate = self
        
        if message.image != nil || message.videoURL != nil {
            cell.width = (tableView.bounds.width * 2/3)
        } else {
            cell.width = cachedBubbleWidths[indexPath] ?? message.text?.estimatedFrame(with: cell.messageLabel.font, maxWidth: (tableView.bounds.width * 2/3) - 16).size.width ?? 0
        }
        
        cachedBubbleWidths[indexPath] = cell.width
        
        if message.isMine {
            cell.isBlue = false
            cell.bubbleView.automaticallyAdjustsColorStyle = true
            cell.updateColors()
        } else {
            cell.isBlue = true
            cell.bubbleView.automaticallyAdjustsColorStyle = false
            cell.bubbleView.backgroundColor = SFColors.blue
            cell.messageLabel.textColor = .white
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cachedHeights[indexPath] else {
            
            let message = messages[indexPath.row]
            
            if let image = message.image {
                let height = ((tableView.bounds.width * 2/3) / (image.size.width / image.size.height)) + 33
                cachedHeights[indexPath] = height
                return height
            } else if message.videoURL != nil {
                let height = tableView.bounds.width * 2/3
                cachedHeights[indexPath] = height
                return height
            } else {
                guard let size = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 15), maxWidth: (self.view.bounds.width * 2/3) - 16) else { return 0 }
                let height = size.height + 33
                cachedHeights[indexPath] = height
                return height
            }
            
        }
        return height
    }
    
}

extension SFChatViewController: SFImageViewerControllerDelegate {
    
    public func willDismiss() {
        activeCell?.messageImageView.alpha = 1
        activeCell?.messageImageView.isUserInteractionEnabled = true
        activeCell?.zoomOut()
    }
    
}

extension SFChatViewController: SFTableViewChatCellDelegate {
    public func didZoomIn(cell: SFTableViewChatCell) {
        activeCell = cell
        let controller = SFImageViewerController(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        controller.modalTransitionStyle = .crossDissolve
        controller.imageViewer.imageView.image = cell.messageImageView.image
        controller.delegate = self
        present(controller, animated: true) {
            cell.messageImageView.alpha = 0
            cell.messageImageView.isUserInteractionEnabled = false
        }
    }
}

extension SFChatViewController: SFPickerControllerDelegate {
    
    open func pickerController(_ pickerController: SFPickerController, didTouch button: UIButton) {
        if button == photosButton {
            showMediaPicker(sourceType: .photoLibrary)
        } else if button == cameraButton {
            showMediaPicker(sourceType: .camera)
        }
    }
    
}
