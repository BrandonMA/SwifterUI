//
//  SFConversationController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

open class SFConversationsCollectionViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    open lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        return layout
    }()
    
    open lazy var collectionView: SFCollectionView = {
        let collectionView = SFCollectionView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    open lazy var chatsManager: SFCollectionManager<SFChat, SFCollectionViewConversationCell, SFCollectionViewHeaderView, SFCollectionViewFooterView> = {
        
        let manager = SFCollectionManager<SFChat, SFCollectionViewConversationCell, SFCollectionViewHeaderView, SFCollectionViewFooterView>()
        
        manager.delegate = self
        
        manager.headerStyler = { (view, section, index) in
            view.titleLabel.text = section.identifier
        }
        
        manager.configure(collectionView: collectionView, itemStyler: { (cell, chat, indexPath) in
            
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
        view.addSubview(collectionView)
        collectionView.clipSides()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reorderChats(notification:)), name: Notification.Name(SFChatNotification.newMessageUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reorderChats(notification:)), name: Notification.Name(SFChatNotification.multipleMessagesUpdate.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChat(notification:)), name: Notification.Name(SFChatNotification.unreadMessagesUpdate.rawValue), object: nil)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewLayout.itemSize = CGSize(width: view.bounds.width - 20, height: 72)
        collectionViewLayout.invalidateLayout()
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

extension SFConversationsCollectionViewController: SFCollectionManagerDelegate {
    
    public func didSelectItem<DataType>(at indexPath: IndexPath, collectionView: SFCollectionView, item: DataType) where DataType : Hashable {
        guard let item = item as? SFChat else { return }
        let chatController = SFChatViewController(chat: item)
        navigationController?.pushViewController(chatController, animated: true)
    }
    
}

extension SFConversationsCollectionViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text == "" {
            chatsManager.forceUpdate(dataSections: user.chats.ordered())
        } else {
            chatsManager.forceUpdate(dataSections: user.chats.filter(by: text).ordered())
        }
    }
}

extension SFConversationsCollectionViewController: SFChatsDelegate {
    
    public func performFullChatsUpdate() {
        chatsManager.updateSections(dataSections: user.chats.ordered())
    }
    
}

extension SFConversationsCollectionViewController: SFContactsViewControllerDelegate {
    
    public func didSelectChat(_ chat: SFChat) {
        let chatController = SFChatViewController(chat: chat)
        navigationController?.pushViewController(chatController, animated: true)
    }
    
}
