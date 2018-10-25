//
//  SFChatViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import MobileCoreServices

open class SFChatViewController: SFViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFVideoPlayerDelegate {
    
    // MARK: - Instance Properties
    
    private var activeCell: SFTableViewChatCell?
    
    open override var inputAccessoryView: UIView? {
        if !isPreview {
            return chatBar
        } else {
            return nil
        }
    }
    
    open var isPreview: Bool = false
    
    open override var canBecomeFirstResponder: Bool { return true }
    
    private var cachedHeights: [IndexPath: CGFloat] = [:]
    private var cachedWidths: [IndexPath: CGFloat] = [:]
    
    private var isWaitingForPopViewController: Bool = false
    
    private weak var currentZoomCell: SFTableViewChatCell?
    private lazy var initialFrameForZooming: CGRect = .zero
    
    open var chat: SFChat
    
    open var adapter = SFTableAdapter<SFMessage, SFTableViewChatCell, SFTableViewHeaderView, SFTableViewFooterView>()
    
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
        chatBar.sendButton.addAction { [unowned self] in self.sendButtonDidTouch() }
        chatBar.fileButton.addAction { [unowned self] in self.mediaButtonDidTouch() }
        return chatBar
    }()
    
    public final lazy var navigationView: SFChatNavigationView = {
        let view = SFChatNavigationView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nameButton.title = chat.name
        if let url = chat.imageURL {
            view.imageView.kf.setImage(with: URL(string: url))
        }
        view.nameButton.addAction { [unowned self] in
            self.showProfile()
        }
        return view
    }()
    
    private lazy var zoomImageView: UIImageView = {
        let zoomImageView = UIImageView()
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.clipsToBounds = true
        zoomImageView.layer.cornerRadius = 10
        return zoomImageView
    }()
    
    // MARK: - Initializers
    
    public init(chat: SFChat, automaticallyAdjustsColorStyle: Bool = true) {
        self.chat = chat
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        adapter.delegate = self
        adapter.insertAnimation = .fade
        adapter.configure(tableView: chatView, dataManager: chat.messagesManager)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        view.addSubview(chatView)
        super.viewWillPrepareSubViews()
    }
    
    open override func viewWillSetConstraints() {
        chatView.clipSides()
        super.viewWillSetConstraints()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newMessage(notification:)), name: Notification.Name(SFChatNotification.newMessage.rawValue), object: nil)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cachedWidths.removeAll()
        cachedHeights.removeAll()
        super.viewWillTransition(to: size, with: coordinator)
        chatView.reloadData()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isWaitingForPopViewController {
            isWaitingForPopViewController.toggle()
        } else {
            DispatchQueue.main.async {
                self.chatView.scrollToBottom(animated: false)
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isPreview {
            chat.markMessagesAsRead()
        }
    }
    
    open override func prepare(navigationController: UINavigationController) {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = navigationView
    }
    
    open override func prepare(tabBarController: UITabBarController) {
        tabBarController.tabBar.isHidden = true
    }
    
    open override func updateColors() {
        super.updateColors()
        if let view = inputAccessoryView as? SFViewColorStyle { view.updateColors() }
        navigationView.updateColors()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let bottomSafeHeight = keyboardHeight - view.safeAreaInsets.bottom
            chatView.contentInset.bottom = bottomSafeHeight < 49 ? 64 : bottomSafeHeight
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
    
    @objc private func keyboardWillHide(notification: Notification) {
        chatView.contentInset.bottom = 64
        chatView.scrollIndicatorInsets.bottom = 64
    }
    
    @objc func newMessage(notification: Notification) {
        chat.markMessagesAsRead()
    }
    
    open func showProfile() {
        
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
    
    open func send(message: SFMessage) -> Bool { return true }
    
    open func getTextMessage(with text: String) -> SFMessage {
        guard let currentUser = chat.currentUser else { fatalError() }
        return SFMessage(senderIdentifier: currentUser.identifier, chatIdentifier: chat.identifier, text: text)
    }
    
    open func upload(textMessage: SFMessage, completion: @escaping (SFMessage, Error?) -> Void) {
        completion(textMessage, nil)
    }
    
    private final func sendButtonDidTouch() {
        if let text = chatBar.textView.text, text != "" {
            let message = getTextMessage(with: text)
            if self.send(message: message) {
                self.chatBar.textView.text = ""
                self.chat.addNew(message: message)
                self.chatView.scrollToBottom()
                upload(textMessage: message) { (message, error) in
                    if error != nil {
                        self.showError(title: "Error al envíar el mensaje", message: "Por favor vuelva a intentarlo")
                        self.chat.messagesManager.deleteItem(message)
                    }
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let message = getImageMessage(with: originalImage, url: "")
            
            if send(message: message) {
                self.chat.addNew(message: message)
                upload(imageMessage: message) { (message, error) in
                    if error != nil {
                        self.showError(title: "Error al subir el archivo", message: "Por favor vuelva a intentarlo")
                        self.chat.messagesManager.deleteItem(message)
                    }
                }
                
                picker.dismiss(animated: true, completion: {
                    self.chatView.scrollToBottom()
                })
            }
        } else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            let message = getVideoMessage(url: videoURL.absoluteString)
            
            if send(message: message) {
                self.chat.addNew(message: message)
                upload(videoMessage: message) { (message, error) in
                    if error != nil {
                        self.showError(title: "Error al subir el archivo", message: "Por favor vuelva a intentarlo")
                        self.chat.messagesManager.deleteItem(message)
                    }
                }
                
                picker.dismiss(animated: true, completion: {
                    self.chatView.scrollToBottom()
                })
            }
        }
    }
    
    open func getImageMessage(with image: UIImage, url: String) -> SFMessage {
        guard let currentUser = chat.currentUser else { fatalError() }
        return SFMessage(senderIdentifier: currentUser.identifier, chatIdentifier: chat.identifier, image: image, imageURL: url)
    }
    
    open func upload(imageMessage: SFMessage, completion: @escaping (SFMessage, Error?) -> Void) {
        completion(imageMessage, nil)
    }
    
    open func getVideoMessage(url: String) -> SFMessage {
        guard let currentUser = chat.currentUser else { fatalError() }
        return SFMessage(senderIdentifier: currentUser.identifier, chatIdentifier: chat.identifier, videoURL: url)
    }
    
    open func upload(videoMessage: SFMessage, completion: @escaping (SFMessage, Error?) -> Void) {
        completion(videoMessage, nil)
    }
}

extension SFChatViewController: SFTableViewChatCellDelegate {
    
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
            self.zoomImageView.layer.cornerRadius = 0
        }, completion: { (_) in
            let zoomViewController = SFImageViewController(with: image)
            let transition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(zoomViewController, animated: false)
        })
    }
    
    private func zoomOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.zoomImageView.frame = self.initialFrameForZooming
            self.zoomImageView.layer.cornerRadius = 10
        }, completion: { (_) in
            self.currentZoomCell?.bubbleView.alpha = 1.0
            self.zoomImageView.removeFromSuperview()
        })
    }
    
}

extension SFChatViewController: SFTableAdapterDelegate {
    
    func calculateWidth(for message: SFMessage, indexPath: IndexPath) {
        if message.videoURL != nil || message.image != nil {
            cachedWidths[indexPath] = (chatView.bounds.width * 2/3)
        } else if message.text != nil {
            cachedWidths[indexPath] = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 17), maxWidth: (chatView.bounds.width * 2/3) - 16).size.width ?? 0
        }
    }
    
    public func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat? {
        
        guard let height = cachedHeights[indexPath] else {
            
            let message = chat.messagesManager.getItem(at: indexPath)
            
            if let image = message.image {
                let height = ((chatView.bounds.width * 2/3) * (image.size.height / image.size.width)) + 56
                cachedHeights[indexPath] = height
                return height
            } else if message.videoURL != nil {
                let height = chatView.bounds.width * 2/3
                cachedHeights[indexPath] = height
                return height
            } else if message.text != nil {
                guard let size = message.text?.estimatedFrame(with: UIFont.systemFont(ofSize: 17), maxWidth: (self.view.bounds.width * 2/3) - 16) else { return 0 }
                let height = size.height + 33 + 48
                cachedHeights[indexPath] = height
                return height
            } else {
                return 106
            }
        }
        return height
    }
    
    public func prepareCell<DataType>(_ cell: SFTableViewCell, at indexPath: IndexPath, with item: DataType) where DataType: Hashable {
        
        guard let cell = cell as? SFTableViewChatCell, let message = item as? SFMessage else { return }
        
        cell.delegate = self
        
        cell.timeLabel.text = message.creationDate.string(with: "HH:mm")
        
        if let imageURL = message.sender?.profilePictureURL {
            cell.userImageView.kf.setImage(with: URL(string: imageURL))
        }
        
        if let image = message.image {
            cell.messageImageView.image = image
            cell.messageVideoView.cleanView()
            cell.messageVideoView.delegate = nil
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            cell.bubbleView.bringSubviewToFront(cell.messageImageView)
            registerForPreviewing(with: self, sourceView: cell.messageImageView)
        } else if let string = message.videoURL, let url = URL(string: string) {
            cell.messageVideoView.delegate = self
            cell.messageVideoView.setVideo(with: url)
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            cell.bubbleView.bringSubviewToFront(cell.messageVideoView)
        } else if message.text != nil {
            cell.messageImageView.image = nil
            cell.messageLabel.text = message.text
            cell.messageVideoView.cleanView()
            cell.messageVideoView.delegate = nil
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
            cell.bubbleView.bringSubviewToFront(cell.messageLabel)
        } else {
            cell.messageImageView.image = nil
            cell.messageLabel.text = nil
            cell.messageVideoView.cleanView()
            cell.messageVideoView.delegate = nil
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
        }
        
        if cachedWidths[indexPath] == nil {
            calculateWidth(for: message, indexPath: indexPath)
        }
        
        cell.width = self.cachedWidths[indexPath] ?? 50.0
        
        cell.isUserInteractionEnabled = true
        
        if message.senderIdentifier == self.chat.currentUser?.identifier {
            cell.bubbleView.useAlternativeColors = true
            cell.isMine = true
            cell.updateColors()
        } else {
            cell.bubbleView.useAlternativeColors = false
            cell.isMine = false
            cell.updateColors()
        }
    }
    
    public var useCustomHeader: Bool { return true }
    
    public func prepareHeader<DataType>(_ view: SFTableViewHeaderView, with section: SFDataSection<DataType>, at index: Int) where DataType: Hashable {
        guard let section = section as? SFDataSection<SFMessage> else { return }
        view.titleLabel.text = section.identifier
        view.titleLabel.textAlignment = .center
        view.titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        view.titleLabel.useAlternativeColors = false
        view.useAlternativeColors = true
    }
    
    public func prefetch<DataType>(item: DataType, at indexPath: IndexPath) where DataType: Hashable {
        guard let message = item as? SFMessage else { return }
        calculateWidth(for: message, indexPath: indexPath)
    }
}

extension SFChatViewController: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        chatBar.sendButton.getConstraint(type: .right)?.constant = -8
        
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
        
        chatBar.sendButton.getConstraint(type: .right)?.constant = 28
        
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

extension SFChatViewController: UIViewControllerPreviewingDelegate {
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = chatView.indexPathForRow(at: location) else { return nil }
        let message = chat.messagesManager.getItem(at: indexPath)
        guard let image = message.image else { return nil }
        let controller = SFImageViewController(with: image)
        controller.animateClosing = true
        return controller
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        isWaitingForPopViewController = true
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

