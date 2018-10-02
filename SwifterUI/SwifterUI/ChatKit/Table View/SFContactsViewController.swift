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

open class SFContactsViewController: SFViewController {
    
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
    
    let adapter = SFTableAdapter<SFUser, SFTableViewContactCell, SFTableViewHeaderView, SFTableViewFooterView>()
        
    open var user: SFUser
    
    // MARK: - Initializers
    
    init(user: SFUser, automaticallyAdjustsColorStyle: Bool = true) {
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.clipSides()
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
}

extension SFContactsViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
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

extension SFContactsViewController: SFTableAdapterDelegate {
    
    public func deleted<DataType>(item: DataType, at indexPath: IndexPath) where DataType : Hashable {
        guard let contact = item as? SFUser else { return }
        user.contactsManager.deleteItem(contact)
        NotificationCenter.default.post(name: Notification.Name(SFUserNotification.deleted.rawValue), object: nil, userInfo: ["SFUser": contact])
        user.chatsManager.flatData.forEach { (chat) in
            guard let chat = chat as? SFSingleChat else { return }
            if chat.contact == contact {
                user.chatsManager.deleteItem(chat)
                NotificationCenter.default.post(name: Notification.Name(SFChatNotification.deleted.rawValue), object: nil, userInfo: ["SFChat": chat])
            }
        }
    }
    
    public func prepareCell<DataType>(_ cell: SFTableViewCell, at indexPath: IndexPath, with data: DataType) where DataType : Hashable {
        
        guard let cell = cell as? SFTableViewContactCell else { return }
        guard let user = data as? SFUser else { return }
        
        cell.nameLabel.text = "\(user.name) \(user.lastName)"
        
        if let string = user.profilePictureURL, let url = URL(string: string) {
            cell.profileImageView.kf.setImage(with: url)
        } else {
            cell.profileImageView.image = nil
        }
    }
    
    public var useCustomHeader: Bool { return true }
    
    public func prepareHeader<DataType>(_ view: SFTableViewHeaderView, with data: SFDataSection<DataType>, index: Int) where DataType : Hashable {
        view.useAlternativeColors = true
        view.titleLabel.useAlternativeColors = true
        view.titleLabel.text = data.identifier
    }
    
    private func getChat(for user: SFUser) -> SFChat {
        
        if let existingChat = user.chatsManager.first?.first(where: { $0.users.contains(user.identifier) && $0.users.count == 2 }) {
            return existingChat
        } else {
            let chat = SFSingleChat(currentUser: self.user, contact: user)
            self.user.addNew(chat: chat)
            user.addNew(chat: chat)
            return chat
        }
    }

    public func didSelectRow<DataType>(at indexPath: IndexPath, tableView: SFTableView, item: DataType) where DataType: Hashable {
        guard let item = item as? SFUser else { return }
        dismiss(animated: true) {
            self.delegate?.didSelectChat(self.getChat(for: item))
        }
    }
    
}

