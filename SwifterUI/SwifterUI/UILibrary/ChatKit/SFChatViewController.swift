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
        let chatBar = SFChatBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        chatBar.translatesAutoresizingMaskIntoConstraints = false
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
            let message = MessageType(senderId: "", text: self.chatBar.textView.text, image: nil, videoURL: nil, fileURL: nil, timestamp: NSDate())
            messages.append(message)
            self.chatBar.textView.text = ""
            if didSend(message: message) {
                chatView.tableView.reloadData()
                chatView.tableView.scrollToBottom(animated: true)
            }
        }
    }
    
    open func didSend(message: MessageType) -> Bool {
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var optionalMessage: MessageType? = nil
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            optionalMessage = MessageType(senderId: "", text: nil, image: originalImage, videoURL: nil, fileURL: nil, timestamp: NSDate())
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            optionalMessage = MessageType(senderId: "", text: nil, image: nil, videoURL: videoURL, fileURL: nil, timestamp: NSDate())
        }
        
        picker.dismiss(animated: true, completion: {
            guard let message = optionalMessage else { return }
            self.messages.append(message)
            if self.didSend(message: message) {
                self.chatView.tableView.reloadData()
                self.chatView.tableView.scrollToBottom(animated: true)
            }
        })
    }
    
    // MARK: - UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SFTableViewChatCell else { return UITableViewCell() }
        
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.messageImageView.image = message.image
        cell.messageVideoView.url = message.videoURL
        cell.isUserInteractionEnabled = true
        cell.messageVideoView.delegate = self
        cell.updateColors()
        
        if let width = cachedBubbleWidths[indexPath] {
            cell.width = width
        } else {
            if message.image != nil || message.videoURL != nil || message.imageURL != nil {
                cell.width = (tableView.bounds.width * 2/3)
            } else {
                cell.width = message.text?.estimatedFrame(with: cell.messageLabel.font, maxWidth: (tableView.bounds.width * 2/3) - 16).size.width ?? 0
            }
        }
        
        if message.isMine {
            cell.isBlue = true
            cell.bubbleView.automaticallyAdjustsColorStyle = false
            cell.bubbleView.backgroundColor = SFColors.blue
            cell.messageLabel.textColor = .white
        } else {
            cell.isBlue = false
            cell.bubbleView.automaticallyAdjustsColorStyle = true
            cell.updateColors()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cachedHeights[indexPath] else {
            
            let message = messages[indexPath.row]
            
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
                guard let size = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 15), maxWidth: (self.view.bounds.width * 2/3) - 16) else { return 0 }
                let height = size.height + 33
                cachedHeights[indexPath] = height
                return height
            }
            
        }
        return height
    }
    
}

extension SFChatViewController: SFTableViewChatCellDelegate {
    public func didZoomIn(cell: SFTableViewChatCell) {
        // TODO: Implement zooming
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

