//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class ViewController: SFViewController {
    
    override func loadView() {
        self.view = SFTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "To Do List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = UISearchController(searchResultsController: nil)
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
}



















