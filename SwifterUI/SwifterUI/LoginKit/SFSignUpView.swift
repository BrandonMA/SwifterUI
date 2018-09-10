//
//  SFSignUpView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 22/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSignUpView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var nameTextField: SFSignViewTextField = {
        let textField = SFSignViewTextField(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textField.placeholder = "Nombre"
        textField.autocapitalizationType = .words
        return textField
    }()
    
    open lazy var lastNameTextField: SFSignViewTextField = {
        let textField = SFSignViewTextField(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textField.placeholder = "Apellidos"
        textField.autocapitalizationType = .words
        return textField
    }()
    
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
    
    open lazy var signUpButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.title = "Crear Cuenta"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.useHighlightTextColor = true
        return button
    }()
    
    private lazy var contentStack: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [nameTextField, lastNameTextField, mailTextField, passwordTextField, signUpButton])
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
        nameTextField.height(SFDimension(value: 42))
        lastNameTextField.height(SFDimension(value: 42))
        mailTextField.height(SFDimension(value: 42))
        passwordTextField.height(SFDimension(value: 42))
        signUpButton.height(SFDimension(value: 52))
        super.setConstraints()
    }
}
