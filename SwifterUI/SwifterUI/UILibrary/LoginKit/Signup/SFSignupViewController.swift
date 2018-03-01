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
        guard let name = signupView.nameSection.getText() else { return }
        guard let lastName = signupView.lastNameSection.getText() else { return }
        guard let email = signupView.mailSection.getText() else { return }
        guard let password = signupView.passwordSection.getText() else { return }
        signup(with: name, lastname: lastName, email: email, password: password)
    }
    
    open func signup(with name: String, lastname: String, email: String, password: String) {
        
    }
    
}
