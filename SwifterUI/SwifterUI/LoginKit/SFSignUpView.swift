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
    
    open lazy var nameSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Nombre"
        section.textField.placeholder = "Escribe..."
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.autocorrectionType = .no
        section.textField.autocapitalizationType = .words
        return section
    }()
    
    open lazy var lastNameSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Apellidos"
        section.textField.placeholder = "Escribe..."
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.autocorrectionType = .no
        section.textField.autocapitalizationType = .words
        return section
    }()
    
    open lazy var mailSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Correo Electronico"
        section.textField.placeholder = "Escribe..."
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.autocorrectionType = .no
        section.textField.autocapitalizationType = .none
        return section
    }()
    
    open lazy var passwordSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Contraseña"
        section.textField.placeholder = "Escribe..."
        section.textField.isSecureTextEntry = true
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.autocorrectionType = .no
        return section
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
        let stack = SFStackView(arrangedSubviews: [nameSection, lastNameSection, mailSection, passwordSection, signUpButton])
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
        contentStack.clipEdges()
        nameSection.height(SFDimension(value: 64))
        lastNameSection.height(SFDimension(value: 64))
        mailSection.height(SFDimension(value: 64))
        passwordSection.height(SFDimension(value: 64))
        signUpButton.height(SFDimension(value: 52))
        super.setConstraints()
    }
}
