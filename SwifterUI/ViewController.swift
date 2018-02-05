//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class ViewController: SFViewController {
    
    var myView: View {
        return view as! View
    }

    override func loadView() {
        self.view = View()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPopView)))
    }
    
    @objc func showPopView() {
        let viewController = SFPopViewController()
        viewController.view.backgroundColor = UIColor.white
        let manager = SFPresentationManager(animation: .pop)
        viewController.transitioningDelegate = manager
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true, completion: nil)
    }
    
}



















