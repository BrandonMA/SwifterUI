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
    
    open lazy var loginView: SFLoginView = {
        let scrollView = SFLoginView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.useAlternativeColors = true
        scrollView.scrollsHorizontally = false
        return scrollView
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        navigationItem.title = "Iniciar Sesión"
        autorotate = UIDevice.current.userInterfaceIdiom == .pad ? true : false
        loginView.logInButton.addTarget(self, action: #selector(logInButtonDidTouch), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTouch), for: .touchUpInside)
        loginView.facebookButton.addTarget(self, action: #selector(facebookButtonDidTouch), for: .touchUpInside)
    }
    
    @objc private func logInButtonDidTouch() {
        guard let email = loginView.mailSection.textField.text else {
            SFWobbleAnimation(with: loginView.mailSection).start()
            return
        }
        
        if email != "" {
            guard let password = loginView.passwordSection.textField.text else {
                SFWobbleAnimation(with: loginView.passwordSection).start()
                return
            }
            
            if password != "" {
                login(with: email, password: password)
            } else {
                SFWobbleAnimation(with: loginView.passwordSection).start()
            }
        } else {
            SFWobbleAnimation(with: loginView.mailSection).start()
        }
    }
    
    open func login(with email: String, password: String) {
        
    }
    
    @objc open func signUpButtonDidTouch() {
        
    }
    
    @objc open func facebookButtonDidTouch() {
        
    }
    
}
