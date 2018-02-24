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
        signupView.facebookButton.addTarget(self, action: #selector(facebookButtonDidTouch), for: .touchUpInside)
    }
    
    @objc private func signUpButtonDidTouch() {
        guard let name = signupView.nameSection.textField.text else {
            SFMorphAnimation(with: signupView.nameSection).start()
            return
        }
        
        if name != "" {
            guard let email = signupView.mailSection.textField.text else {
                SFMorphAnimation(with: signupView.mailSection).start()
                return
            }
            
            if email != "" {
                guard let password = signupView.passwordSection.textField.text else {
                    SFMorphAnimation(with: signupView.passwordSection).start()
                    return
                }
                
                if password != "" {
                    signup(with: name, email: email, password: password)
                } else {
                    SFMorphAnimation(with: signupView.passwordSection).start()
                }
            } else {
                SFMorphAnimation(with: signupView.mailSection).start()
            }
        } else {
            SFMorphAnimation(with: signupView.nameSection).start()
        }
    }
    
    open func signup(with name: String, email: String, password: String) {
        
    }
    
    @objc open func facebookButtonDidTouch() {
        
    }
    
}
