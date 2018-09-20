////
////  SFContactsViewController
////  SwifterUI
////
////  Created by brandon maldonado alonso on 8/28/18.
////  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//
//public protocol SFContactsViewControllerDelegate: class {
//    func didSelectChat(_ chat: SFChat)
//}
//
//open class SFContactsViewController: SFViewController {
//    
//    // MARK: - Instance Properties
//    
//    public final weak var delegate: SFContactsViewControllerDelegate?
//    
//    open lazy var tableView: SFTableView = {
//        let tableView = SFTableView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//    
//    open lazy var searchController: UISearchController = {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        return searchController
//    }()
//    
//    open lazy var contactsManager: SFTableManager<SFUser, SFTableViewContactCell, SFTableViewHeaderView, SFTableViewFooterView> = {
//        
//        let manager = SFTableManager<SFUser, SFTableViewContactCell, SFTableViewHeaderView, SFTableViewFooterView>()
//        
//        manager.tableDelegate = self
//        
//        manager.addIndexList = true
//        
//        manager.headerStyler = { (view, section, index) in
//            view.useAlternativeColors = true
//            view.titleLabel.useAlternativeColors = true
//            view.titleLabel.text = section.identifier
//        }
//        
//        manager.configure(tableView: tableView, cellStyler: { (cell, user, indexPath) in
//            cell.nameLabel.text = "\(user.name) \(user.lastName)"
//            
//            if let string = user.profilePictureURL, let url = URL(string: string) {
//                cell.profileImageView.kf.setImage(with: url)
//            } else {
//                cell.profileImageView.image = nil
//            }
//        })
//        
//        return manager
//    }()
//    
//    open var user: SFUser
//    
//    // MARK: - Initializers
//    
//    init(user: SFUser, automaticallyAdjustsColorStyle: Bool = true) {
//        self.user = user
//        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
//        self.user.contactsDelegate = self
//        contactsManager.update(dataSections: user.contacts.ordered())
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Instance Methods
//    
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(tableView)
//        tableView.clipSides()
//    }
//    
//    open override func prepare(navigationController: UINavigationController) {
//        super.prepare(navigationController: navigationController)
//        navigationItem.title = "Contactos"
//        definesPresentationContext = true
//        navigationItem.searchController = searchController
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
//    }
//    
//    @objc func dismissViewController() {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//extension SFContactsViewController: UISearchResultsUpdating {
//    
//    public func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        if text == "" { contactsManager.forceUpdate(dataSections: user.contacts.ordered()) }
//        else { contactsManager.forceUpdate(dataSections: user.contacts.filter(by: text).ordered()) }
//    }
//    
//}
//
//extension SFContactsViewController: SFTableManagerDelegate {
//    
////    private func getChat(for user: SFUser) -> SFChat {
////        if let existingChat = user.chats.first(where: { $0.users.contains(user.identifier) && $0.users.count == 2 }) {
////            return existingChat
////        } else {
////            return SFSingleChat(currentUser: user, contact: user)
////        }
////    }
////    
////    public func didSelectRow<DataType>(at indexPath: IndexPath, tableView: SFTableView, item: DataType) where DataType: Hashable {
////        
////        guard let item = item as? SFUser else { return }
////        
////        if let navigationController = navigationController {
////            navigationController.popToRootViewController(animated: true)
////            delegate?.didSelectChat(getChat(for: item))
////        } else {
////            dismiss(animated: true, completion: nil)
////        }
////    }
//    
//}
//
//extension SFContactsViewController: SFContactsDelegate {
//    
//    public func performFullContactsUpdate() {
//        contactsManager.updateSections(dataSections: user.contacts.ordered())
//    }
//    
//}
