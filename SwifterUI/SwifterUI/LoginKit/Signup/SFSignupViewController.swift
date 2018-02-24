//
//  SFSignupViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 23/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSignupViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open lazy var scrollView: SFSignupView = {
        let scrollView = SFSignupView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
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
        scrollView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTouch), for: .touchUpInside)
        scrollView.facebookButton.addTarget(self, action: #selector(facebookButtonDidTouch), for: .touchUpInside)
    }
    
    @objc open func signUpButtonDidTouch() {
        
    }
    
    @objc open func facebookButtonDidTouch() {
        
    }
    
}
