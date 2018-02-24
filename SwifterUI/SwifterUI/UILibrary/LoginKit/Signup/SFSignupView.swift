//
//  SFSignupView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 23/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSignupView: SFScrollView {
    
    // MARK: - Instance Properties
    
    open lazy var nameSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Nombre"
        section.textField.placeholder = "Escribe..."
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.useAlternativeColors = true
        section.textField.autocorrectionType = .no
        return section
    }()
    
    open lazy var mailSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Correo Electronico"
        section.textField.placeholder = "Escribe..."
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.useAlternativeColors = true
        section.textField.autocorrectionType = .no
        return section
    }()
    
    open lazy var passwordSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Contraseña"
        section.textField.placeholder = "Escribe..."
        section.textField.isSecureTextEntry = true
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.useAlternativeColors = true
        section.textField.autocorrectionType = .no
        return section
    }()
    
    open lazy var signUpButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Crear Cuenta", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useAlternativeColors = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        contentView.addSubview(nameSection)
        contentView.addSubview(mailSection)
        contentView.addSubview(passwordSection)
        contentView.addSubview(signUpButton)
        useAlternativeColors = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        
        nameSection.clipEdges(margin: ConstraintMargin(top: 16, right: 16, bottom: 0, left: 16), exclude: [.bottom])
        
        mailSection.clipEdges(margin: ConstraintMargin(top: 0, right: 16, bottom: 0, left: 16), exclude: [.top, .bottom])
        mailSection.clipTop(to: .bottom, of: nameSection, margin: 16)
        
        passwordSection.clipEdges(margin: ConstraintMargin(top: 0, right: 16, bottom: 0, left: 16), exclude: [.top, .bottom])
        passwordSection.clipTop(to: .bottom, of: mailSection, margin: 16)
        
        signUpButton.clipEdges(margin: ConstraintMargin(top: 16, right: 16, bottom: 0, left: 16), exclude: [.top, .bottom])
        signUpButton.clipTop(to: .bottom, of: passwordSection, margin: 16)
        signUpButton.height(SFDimension(value: 44))
        
        contentView.clipBottom(to: .bottom, of: signUpButton, margin: -16)
    }
}
