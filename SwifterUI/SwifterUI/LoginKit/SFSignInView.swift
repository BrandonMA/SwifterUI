//
//  SFSignInView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 22/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSignInView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var mailTextField: SFSignViewTextField = {
        let textField = SFSignViewTextField(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textField.placeholder = "Correo Electronico"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    open lazy var passwordTextField: SFSignViewTextField = {
        let textField = SFSignViewTextField(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textField.placeholder = "Contraseña"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    open lazy var signInButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.title = "Iniciar Sesión"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.useHighlightTextColor = true
        return button
    }()
    
    open lazy var passwordResetButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.title = "Cambiar contraseña"
        button.useHighlightTextColor = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var contentStack: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [mailTextField, passwordTextField, signInButton, passwordResetButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(contentStack)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        contentStack.clipSides()
        mailTextField.set(height: SFDimension(value: 40))
        passwordTextField.set(height: SFDimension(value: 40))
        passwordResetButton.set(height: SFDimension(value: 52))
        signInButton.set(height: SFDimension(value: 52))
        super.setConstraints()
    }
}
