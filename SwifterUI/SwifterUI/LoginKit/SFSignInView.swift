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
    
    open lazy var signInButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Iniciar Sesión", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.addTouchAnimations = true
        return button
    }()
    
    private lazy var contentStack: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [mailSection, passwordSection, signInButton])
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
        mailSection.height(SFDimension(value: 64))
        passwordSection.height(SFDimension(value: 64))
        signInButton.height(SFDimension(value: 52))
        super.updateConstraints()
    }
}
