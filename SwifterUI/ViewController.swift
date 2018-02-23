//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class LoginView: SFScrollView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var mailSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Correo Electronico"
        section.textField.placeholder = "Escribe..."
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.useAlternativeColors = true
        return section
    }()
    
    lazy var passwordSection: SFTextSection = {
        let section = SFTextSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.titleLabel.text = "Contraseña"
        section.textField.placeholder = "Escribe..."
        section.textField.isSecureTextEntry = true
        section.translatesAutoresizingMaskIntoConstraints = false
        section.textField.useAlternativeColors = true
        return section
    }()
    
    lazy var logInButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Iniciar Sesión", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useAlternativeColors = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(mailSection)
        contentView.addSubview(passwordSection)
        contentView.addSubview(logInButton)
        useAlternativeColors = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        
        imageView.clipEdges(margin: ConstraintMargin(top: 16, right: 16, bottom: 0, left: 16), exclude: [.bottom])
        imageView.height(SFDimension(value: 200))
        
        mailSection.clipEdges(margin: ConstraintMargin(top: 0, right: 16, bottom: 0, left: 16), exclude: [.top, .bottom])
        mailSection.clipTop(to: .bottom, of: imageView, margin: 16)
        
        passwordSection.clipEdges(margin: ConstraintMargin(top: 0, right: 16, bottom: 0, left: 16), exclude: [.top, .bottom])
        passwordSection.clipTop(to: .bottom, of: mailSection, margin: 16)
        
        logInButton.clipEdges(margin: ConstraintMargin(top: 16, right: 16, bottom: 0, left: 16), exclude: [.top, .bottom])
        logInButton.clipTop(to: .bottom, of: passwordSection, margin: 16)
        logInButton.height(SFDimension(value: 44))
        
        contentView.clipBottom(to: .bottom, of: logInButton, margin: -16)
    }
}

class ViewController: SFViewController {
    
    lazy var scrollView: LoginView = {
        let scrollView = LoginView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.useAlternativeColors = true
        scrollView.scrollsHorizontally = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
    }
}

open class Message: SFMessage {
    
    open var text: String?
    open var image: UIImage?
    open var videoURL: URL?
    open var fileURL: URL?
    public var isMine: Bool
    open var timestamp: Date
    
    public required init(text: String? = nil, image: UIImage? = nil, videoURL: URL? = nil, fileURL: URL? = nil, isMine: Bool = true, timestamp: Date) {
        self.text = text
        self.image = image
        self.videoURL = videoURL
        self.fileURL = fileURL
        self.isMine = isMine
        self.timestamp = timestamp
    }
    
}


























