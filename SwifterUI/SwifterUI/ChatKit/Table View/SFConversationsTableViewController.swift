//
//  SFConversationsTableViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/30/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

open class SFConversationsViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    open lazy var tableView: SFTableView = {
        let tableView = SFTableView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    open var adapter = SFTableAdapter<SFChat, SFTableViewConversationCell, SFTableViewHeaderView, SFTableViewFooterView>()
    
    open var user: SFUser
    
    // MARK: - Initializers
    
    public init(user: SFUser, automaticallyAdjustsColorStyle: Bool = true) {
        self.user = user
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        adapter.delegate = self
        adapter.insertAnimation = .left
        adapter.deleteAnimation = .right
        adapter.updateAnimation = .none
        adapter.enableEditing = false
        adapter.configure(tableView: tableView, dataManager: user.chatsManager)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        view.addSubview(tableView)
        super.viewWillPrepareSubViews()
    }
    
    open override func viewWillSetConstraints() {
        tableView.clipSides()
        super.viewWillSetConstraints()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(newMessage(notification:)), name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil)
    }
    
    open override func prepare(navigationController: UINavigationController) {
        super.prepare(navigationController: navigationController)
        navigationItem.largeTitleDisplayMode = .always
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Chats"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showContactsViewController))
    }
    
    @objc open func showContactsViewController() {
        let contactsViewController = SFContactsViewController(user: user)
        contactsViewController.delegate = self
        present(SFNavigationController(rootViewController: contactsViewController), animated: true)
    }
    
    @objc open func newMessage(notification: Notification) {
        if let chat = notification.userInfo?["SFChat"] as? SFChat {
            user.chatsManager.enumerated().forEach { (sectionIndex, section) in
                section.enumerated().forEach({ (itemIndex, item) in
                    if item == chat {
                        let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                        user.chatsManager.moveItem(from: indexPath, to: IndexPath(item: 0, section: 0))
                        user.chatsManager.updateItem(item)
                    }
                })
            }
        }
    }
    
    open func delete(chat: SFChat) {
        
    }
    
    open func open(chat: SFChat) {
        let chatController = SFChatViewController(chat: chat)
        navigationController?.pushViewController(chatController, animated: true)
    }
    
}

extension SFConversationsViewController: SFContactsViewControllerDelegate {
    public func didSelectChat(_ chat: SFChat) {
        open(chat: chat)
    }
}

extension SFConversationsViewController: SFTableAdapterDelegate {
    
    public func prepareCell<DataType>(_ cell: SFTableViewCell, at indexPath: IndexPath, with item: DataType) where DataType: DiffAware {
        
        guard let cell = cell as? SFTableViewConversationCell, let chat = item as? SFChat else { return }
        
        cell.conversationView.nameLabel.text = "\(chat.name)"
        
        if let string = chat.imageURL, let url = URL(string: string) {
            cell.conversationView.profileImageView.kf.setImage(with: url)
        } else {
            cell.conversationView.profileImageView.image = nil
        }
        
        if let message = chat.messagesManager.lastItem {
            if message.imageURL != nil || message.image != nil {
                cell.conversationView.messageLabel.text = message.senderIdentifier == chat.currentUser?.identifier ? "Has enviado una imagen" : "Has recibido una imagen"
            } else if message.videoURL != nil {
                cell.conversationView.messageLabel.text = message.senderIdentifier == chat.currentUser?.identifier ? "Has enviado un video" : "Has recibido un video"
            } else if message.text != nil {
                cell.conversationView.messageLabel.text = message.text
            }
        } else {
            cell.conversationView.messageLabel.text = ""
        }
        
        if Calendar.current.isDateInToday(chat.modificationDate) {
            cell.conversationView.hourLabel.text = chat.modificationDate.string(with: "HH:mm")
        } else if Calendar.current.isDateInYesterday(chat.modificationDate) {
            cell.conversationView.hourLabel.text = "Ayer"
        } else {
            cell.conversationView.hourLabel.text = chat.modificationDate.string(with: "MMMM d")
        }
        
        if chat.unreadMessages > 0 {
            cell.conversationView.notificationIndicator.alpha = 1
        } else {
            cell.conversationView.notificationIndicator.alpha = 0
        }
        
        cell.conversationView.notificationIndicator.titleLabel.text = "\(chat.unreadMessages)"
        
//        registerForPreviewing(with: self, sourceView: cell)
    }
    
    public func deleted<DataType>(item: DataType, at indexPath: IndexPath) where DataType: DiffAware {
        guard let chat = item as? SFChat else { return }
        user.contactsManager.flatData.forEach { (contact) in
            contact.chatsManager.deleteItem(chat)
            NotificationCenter.default.post(name: Notification.Name(SFChatNotification.deleted.rawValue), object: nil, userInfo: ["SFChat": chat])
            delete(chat: chat)
        }
    }
    
    public func didSelectCell<DataType>(with item: DataType, at indexPath: IndexPath, tableView: SFTableView) where DataType: DiffAware {
        guard let chat = item as? SFChat else { return }
        open(chat: chat)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SFConversationsViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text == "" {
            adapter.clearSearch()
        } else {
            adapter.search { (chat) -> Bool in
                return chat.name.lowercased().contains(text.lowercased())
            }
        }
    }
}

//extension SFConversationsViewController: UIViewControllerPreviewingDelegate {
//
//    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
//        let chat = user.chatsManager.getItem(at: indexPath)
//        let controller = SFChatViewController(chat: chat)
//        controller.isPreview = true
//        return controller
//    }
//
//    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        guard let viewControllerToCommit = viewControllerToCommit as? SFChatViewController else { return }
//        viewControllerToCommit.isPreview = false
//        navigationController?.pushViewController(viewControllerToCommit, animated: true)
//
//    }
//}
