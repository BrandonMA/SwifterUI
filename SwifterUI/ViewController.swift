//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class View: SFView {
    
    lazy var button: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.addTouchAnimations = true
        button.setTitle("Button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textView: SFTextScrollSection = {
        let section = SFTextScrollSection(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        section.translatesAutoresizingMaskIntoConstraints = false
        section.titleLabel.text = "Prueba"
        section.textView.text = "dhsaldufhasliufhasdilufhadilusfhasiludhfliuasdhfiluasdhfuilasdhf liasudhflaisudfhasldiufhalisu aiudhfalsdiufhasdlif asiludfhaslidufhas liasdufasjfbasd.mnf asdlh clashvflasidfgasdlkf asdlhf as dfiabdfñiasdbfakns dflhas dy"
        return section
    }()
    
    override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(button)
        addSubview(textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func updateConstraints() {
        button.center()
        button.height(SFDimension(value: 100))
        button.width(SFDimension(value: 100))
        textView.clipLeft(to: .left)
        textView.clipRight(to: .right)
        textView.clipBottom(to: .top, of: button, margin: 16)
        textView.height(SFDimension(value: 58))
        super.updateConstraints()
    }
    
}

class ViewController: SFViewController {
    
    lazy var mainView: View = {
        let view = View(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.button.addTarget(self, action: #selector(presentBulletin), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.clipEdges()
    }
    
    @objc func presentBulletin() {
//        let popViewController = SFPopViewController(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
//        let manager = SFPresentationManager(animation: .pop)
//        popViewController.transitioningDelegate = manager
//        popViewController.modalPresentationStyle = .custom
//        present(popViewController, animated: true, completion: nil)
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setTitle("Boton", for: .normal)
        button.add {
            print("Hi")
        }
        let controller = SFAlertViewController(title: "Hola", message: "Este es el mensaje", buttons: [button])
        present(controller, animated: true)
//        let controller = SFBulletinController(buttons: [button])
//        present(controller, animated: true, completion: nil)
//        let controller = SFPopViewController()
//        present(controller, animated: true, completion: nil)
    }
}


















































