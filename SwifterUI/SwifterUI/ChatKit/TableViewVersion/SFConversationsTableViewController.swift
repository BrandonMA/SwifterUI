//
//  SFConversationsTableViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/30/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFConversationsTableViewController: SFViewController {
    
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
    
    open lazy var chatsManager: SFTableManager<SFChat, SFTableViewConversationCell, SFTableViewHeaderView, SFTableViewFooterView> = {
        
        let manager = SFTableManager<SFChat, SFTableViewConversationCell, SFTableViewHeaderView, SFTableViewFooterView>()
        
        manager.delegate = self
        
        manager.headerStyler = { (view, section, index) in
            view.titleLabel.text = section.identifier
        }
        
        manager.configure(tableView: tableView, cellStyler: { (cell, chat, indexPath) in
            
            cell.conversationView.nameLabel.text = "\(chat.name)"
            
            if let image = chat.image {
                cell.conversationView.profileImageView.image = image
            } else if let string = chat.imageURL, let url = URL(string: string) {
                cell.conversationView.profileImageView.kf.setImage(with: url)
            } else {
                cell.conversationView.profileImageView.image = nil
            }
            
            if let message = chat.messages.last {
                if message.imageURL != nil || message.image != nil {
                    cell.conversationView.messageLabel.text = message.senderIdentifier == chat.currentUser.identifier ? "Has enviado una imagen" : "Has recibido una imagen"
                } else if message.videoURL != nil {
                    cell.conversationView.messageLabel.text = message.senderIdentifier == chat.currentUser.identifier ? "Has enviado un video" : "Has recibido un video"
                } else if message.text != nil {
                    cell.conversationView.messageLabel.text = message.text
                }
            } else {
                cell.conversationView.messageLabel.text = ""
            }
            
            cell.conversationView.hourLabel.text = chat.modificationDate.string(with: "HH:mm")
            
            if chat.unreadMessages > 0 {
                cell.conversationView.notificationIndicator.alpha = 1
            } else {
                cell.conversationView.notificationIndicator.alpha = 0
            }
            cell.conversationView.notificationIndicator.titleLabel.text = "\(chat.unreadMessages)"
        })
        
        return manager
    }()
    
    open var user: SFUser
    
    // MARK: - Initializers
    
    init(user: SFUser, automaticallyAdjustsColorStyle: Bool = true) {
        self.user = user
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        user.chatsDelegate = self
        chatsManager.update(dataSections: user.chats.ordered())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.clipSides()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reorderChats(notification:)), name: Notification.Name(SFChatNotification.newMessageUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reorderChats(notification:)), name: Notification.Name(SFChatNotification.multipleMessagesUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChat(notification:)), name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil)
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
    
    @objc func showContactsViewController() {
        let contactsViewController = SFContactsViewController(user: user)
        contactsViewController.delegate = self
        navigationController?.pushViewController(contactsViewController, animated: true)
    }
    
    @objc func reorderChats(notification: Notification) {
        if let chat = notification.userInfo?["SFChat"] as? SFChat {
            if let indexPath = chatsManager.indexOf(item: chat) {
                firstly {
                    chatsManager.reloadItem(from: indexPath)
                }.then({
                    self.chatsManager.moveItem(from: indexPath, to: IndexPath(item: 0, section: 0))
                })
            }
        }
    }
    
    @objc func reloadChat(notification: Notification) {
        if let chat = notification.userInfo?["SFChat"] as? SFChat {
            if let indexPath = chatsManager.indexOf(item: chat) {
                chatsManager.reloadItem(from: indexPath)
            }
        }
    }
}

extension SFConversationsTableViewController: SFTableManagerDelegate {
    public func didSelectRow<DataType>(at indexPath: IndexPath, tableView: SFTableView, item: DataType) where DataType : Hashable {
        guard let item = item as? SFChat else { return }
        let chatController = SFChatViewController(chat: item)
        navigationController?.pushViewController(chatController, animated: true)
    }
}

extension SFConversationsTableViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text == "" {
            chatsManager.forceUpdate(dataSections: user.chats.ordered())
        } else {
            chatsManager.forceUpdate(dataSections: user.chats.filter(by: text).ordered())
        }
    }
    
}

extension SFConversationsTableViewController: SFChatsDelegate {
    
    public func performFullChatsUpdate() {
        chatsManager.updateSections(dataSections: user.chats.ordered())
    }
    
}

extension SFConversationsTableViewController: SFContactsViewControllerDelegate {
    
    public func didSelectChat(_ chat: SFChat) {
        let chatController = SFChatViewController(chat: chat)
        navigationController?.pushViewController(chatController, animated: true)
    }
    
}
