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
    
    public lazy var contentStack: SFStackView = {
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
    
    public lazy var signUpButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Crear Cuenta"
        button.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    public lazy var signInButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, useAlternativeColors: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Iniciar Sesión"
        button.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
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
        return view
    }()
    
    open lazy var facebookButton: SFFluidButton = {
        let button = SFFluidButton(automaticallyAdjustsColorStyle: false)
        button.title = "Facebook"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.normalColor = UIColor(hex: "3B5998")
        button.textColor = .white
        button.highlightedColor = UIColor(hex: "2d4577")
        button.highlightedTextColor = UIColor.white
        button.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        scrollsHorizontally = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        contentView.addSubview(contentStack)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        contentStack.clipSides(exclude: [.bottom], margin: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        imageView.height(SFDimension(value: 160))
        labelsStack.height(SFDimension(value: 32))
        facebookButton.height(SFDimension(value: 52))
        contentView.clipBottom(to: .bottom, of: contentStack, margin: -16)
        super.setConstraints()
    }
    
    open override func updateColors() {
        signUpView.updateColors()
        signInView.updateColors()
        super.updateColors()
    }
}
