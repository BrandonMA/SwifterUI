//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class ViewController: SFViewController {
    
    lazy var tableView: SFTableView = {
        let tableView = SFTableView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.clipEdges()
        tableView.register(SFTableViewChatCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SFTableViewChatCell else { return UITableViewCell() }
        cell.profileImageView.download(from: "https://www.cesarsway.com/sites/newcesarsway/files/styles/large_article_preview/public/The-stages-of-puppy-growth.jpg?itok=9ptPJwY8")
        cell.nameLabel.text = "Brandon"
        cell.messageLabel.text = "Este es el mensaje"
        cell.hourLabel.text = Date.today(with: "dd/mm/yyyy")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = SFPopViewController()
        let manager = SFPresentationManager(animation: .pop)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = manager
        present(controller, animated: true, completion: nil)
    }
}
















