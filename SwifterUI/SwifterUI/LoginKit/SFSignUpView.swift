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
    
    open lazy var signUpButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Crear Cuenta", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTouchAnimations = true
        return button
    }()
    
    private lazy var contentStack: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [nameSection, lastNameSection, mailSection, passwordSection, signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(contentStack)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        contentStack.clipEdges()
        nameSection.height(SFDimension(value: 58))
        lastNameSection.height(SFDimension(value: 58))
        mailSection.height(SFDimension(value: 58))
        passwordSection.height(SFDimension(value: 58))
        signUpButton.height(SFDimension(value: 44))
        super.updateConstraints()
    }
}
