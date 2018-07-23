//
//  SFSignView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 22/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSignView: SFScrollView {
    
    // MARK: - Instance Properties
    
    private lazy var contentStack: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [imageView, labelsStack, signUpView, signInView, facebookButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var labelsStack: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [signUpButton, signInButton])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    public lazy var signUpButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Crear Cuenta"
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTouchAnimations = true
        button.useAlternativeColors = true
        return button
    }()
    
    public lazy var signInButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Iniciar Sesión"
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTouchAnimations = true
        button.useAlternativeColors = true
        return button
    }()
    
    public lazy var signUpView: SFSignUpView = {
        let view = SFSignUpView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var signInView: SFSignInView = {
        let view = SFSignInView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    open lazy var facebookButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: false)
        button.title = "Facebook"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "3B5998")
        button.layer.cornerRadius = 10
        button.addTouchAnimations = true
        return button
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        contentView.addSubview(contentStack)
        scrollsHorizontally = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        if mainContraints.isEmpty {
            mainContraints.append(contentsOf: contentStack.clipEdges(exclude: [.bottom], margin: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)))
            mainContraints.append(imageView.height(SFDimension(value: 160)))
            mainContraints.append(labelsStack.height(SFDimension(value: 32)))
            mainContraints.append(facebookButton.height(SFDimension(value: 52)))
            mainContraints.append(contentView.clipBottom(to: .bottom, of: contentStack, margin: -16))
        }
    }
}
