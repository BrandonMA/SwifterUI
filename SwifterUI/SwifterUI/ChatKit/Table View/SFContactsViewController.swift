//
//  SFContactsViewController
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/28/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import Kingfisher

public protocol SFContactsViewControllerDelegate: class {
    func didSelectChat(_ chat: SFChat)
}

open class SFContactsViewController: SFViewController, SFTableAdapterDelegate, UISearchResultsUpdating {
    
    // MARK: - Instance Properties
    
    public final weak var delegate: SFContactsViewControllerDelegate?
    
    open lazy var tableView: SFTableView = {
        let tableView = SFTableView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    open lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    open var adapter = SFTableAdapter<SFUser, SFTableViewContactCell, SFTableViewHeaderView, SFTableViewFooterView>()
    
    open var user: SFUser
    
    // MARK: - Initializers
    
    public init(user: SFUser, automaticallyAdjustsColorStyle: Bool = true) {
        self.user = user
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        adapter.delegate = self
        adapter.addIndexList = true
        adapter.insertAnimation = .left
        adapter.deleteAnimation = .right
        adapter.enableEditing = true
        adapter.configure(tableView: tableView, dataManager: user.contactsManager)
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
    
    open override func prepare(navigationController: UINavigationController) {
        super.prepare(navigationController: navigationController)
        navigationItem.title = "Contactos"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    open func delete(contact: SFUser) {
        
    }
    
    open func delete(chat: SFChat) {
        
    }
    
    open func getChat(for user: SFUser) -> SFChat {
        
        if let existingChat = user.chatsManager.first?.first(where: { $0.users.contains(user.identifier) && $0.users.count == 2 }) {
            return existingChat
        } else {
            let chat = SFSingleChat(users: [self.user.identifier, user.identifier], messages: [], name: "\(user.name) \(user.lastName)")
            chat.currentUser = self.user
            chat.contact = user
            self.user.addNew(chat: chat)
            user.addNew(chat: chat)
            return chat
        }
    }
    
    // MARK: - SFTableAdapterDelegate
    
    open func deleted<DataType>(item: DataType, at indexPath: IndexPath) where DataType: Hashable {
        guard let contact = item as? SFUser else { return }
        NotificationCenter.default.post(name: Notification.Name(SFUserNotification.deleted.rawValue), object: nil, userInfo: ["SFUser": contact])
        delete(contact: contact)
        user.chatsManager.flatData.forEach { (chat) in
            guard let chat = chat as? SFSingleChat else { return }
            if chat.contact == contact {
                user.chatsManager.deleteItem(chat)
                NotificationCenter.default.post(name: Notification.Name(SFChatNotification.deleted.rawValue), object: nil, userInfo: ["SFChat": chat])
                delete(chat: chat)
            }
        }
    }

    open func prepareCell<DataType>(_ cell: SFTableViewCell, at indexPath: IndexPath, with item: DataType) where DataType: Hashable {
        
        guard let cell = cell as? SFTableViewContactCell, let user = item as? SFUser else { return }
        
        cell.nameLabel.text = "\(user.name) \(user.lastName)"
        
        if let string = user.profilePictureURL, let url = URL(string: string) {
            cell.profileImageView.kf.setImage(with: url)
        } else {
            cell.profileImageView.image = nil
        }
    }
    
    open var useCustomHeader: Bool { return true }
    
    open func prepareHeader<DataType>(_ view: SFTableViewHeaderView, with section: SFDataSection<DataType>, at index: Int) where DataType: Hashable {
        view.useAlternativeColors = true
        view.titleLabel.useAlternativeColors = true
        view.titleLabel.text = section.identifier
    }

    open func didSelectCell<DataType>(_ cell: SFTableViewCell, at indexPath: IndexPath, item: DataType, tableView: SFTableView) where DataType: Hashable {
        guard let item = item as? SFUser else { return }
        let chat = getChat(for: item)
        dismiss(animated: true) {
            self.delegate?.didSelectChat(chat)
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    open func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text == "" {
            adapter.clearSearch()
        } else {
            adapter.search { (user) -> Bool in
                return "\(user.name) \(user.lastName)".lowercased().contains(text.lowercased())
            }
        }
    }
}
