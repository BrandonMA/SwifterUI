//
//  SFLoginViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 23/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFLoginViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open lazy var scrollView: SFLoginView = {
        let scrollView = SFLoginView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.useAlternativeColors = true
        scrollView.scrollsHorizontally = false
        return scrollView
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        autorotate = UIDevice.current.userInterfaceIdiom == .pad ? true : false
        scrollView.logInButton.addTarget(self, action: #selector(logInButtonDidTouch), for: .touchUpInside)
        scrollView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTouch), for: .touchUpInside)
        scrollView.facebookButton.addTarget(self, action: #selector(facebookButtonDidTouch), for: .touchUpInside)
    }
    
    @objc open func logInButtonDidTouch() {
        
    }
    
    @objc open func signUpButtonDidTouch() {
        let controller = SFSignupViewController(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc open func facebookButtonDidTouch() {
        
    }
    
}
