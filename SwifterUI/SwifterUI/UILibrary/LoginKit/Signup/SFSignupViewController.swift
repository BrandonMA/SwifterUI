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
    
    open lazy var signupView: SFSignupView = {
        let scrollView = SFSignupView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.useAlternativeColors = true
        scrollView.scrollsHorizontally = false
        return scrollView
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signupView)
        navigationItem.title = "Crear Cuenta"
        autorotate = UIDevice.current.userInterfaceIdiom == .pad ? true : false
        signupView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTouch), for: .touchUpInside)
    }
    
    @objc private func signUpButtonDidTouch() {
        guard let name = signupView.nameSection.textField.text else {
            SFWobbleAnimation(with: signupView.nameSection).start()
            return
        }
        
        if name != "" {
            guard let lastName = signupView.lastNameSection.textField.text else {
                SFWobbleAnimation(with: signupView.lastNameSection).start()
                return
            }
            
            if lastName != "" {
                guard let email = signupView.mailSection.textField.text else {
                    SFWobbleAnimation(with: signupView.mailSection).start()
                    return
                }
                
                if email != "" {
                    guard let password = signupView.passwordSection.textField.text else {
                        SFWobbleAnimation(with: signupView.passwordSection).start()
                        return
                    }
                    
                    if password != "" {
                        signup(with: name, lastname: lastName, email: email, password: password)
                    } else {
                        SFWobbleAnimation(with: signupView.passwordSection).start()
                    }
                } else {
                    SFWobbleAnimation(with: signupView.mailSection).start()
                }
            } else {
                SFWobbleAnimation(with: signupView.lastNameSection).start()
            }
        } else {
            SFWobbleAnimation(with: signupView.nameSection).start()
        }
    }
    
    open func signup(with name: String, lastname: String, email: String, password: String) {
        
    }
    
}
