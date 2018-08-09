//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff
import PromiseKit

struct FirebaseMessage: SFMessage {
    
    // MARK: - Static Methods
    
    public static func == (lhs: FirebaseMessage, rhs: FirebaseMessage) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // MARK: - Instance Properties
    
    var identifier: String = ""
    var senderIdentifier: String = ""
    var text: String?
    var imageURL: URL?
    var image: UIImage?
    var videoURL: URL?
    var fileURL: URL?
    var timestamp: Date = Date()
    var isMine: Bool = true
    
    // MARK: - Initializers
    
    public init(senderIdentifier: String, text: String? = nil, image: UIImage? = nil, videoURL: URL? = nil, fileURL: URL? = nil, timestamp: Date, isMine: Bool) {
        self.identifier = UUID().uuidString
        self.senderIdentifier = senderIdentifier
        self.text = text
        self.image = image
        self.imageURL = nil
        self.videoURL = videoURL
        self.fileURL = fileURL
        self.timestamp = timestamp
        self.isMine = isMine
    }
    
}

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
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: useAlternativeColors, useAlternativeColors: useAlternativeColors, frame: frame)
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
    
    lazy var tableView: SFTableView = {
        let view = SFTableView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 32
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: SFCollectionView = {
        let collectionView = SFCollectionView(collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let tableManager = SFTableManager<String, SFTableViewCell, SFTableViewHeaderView, SFTableViewFooterView>()
    let collectionManager = SFCollectionManager<String, SFCollectionViewCell, SFCollectionViewHeaderView, SFCollectionViewFooterView>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(collectionView)

        collectionManager.configure(collectionView: collectionView) { (cell, model, indexPath) in
            cell.isUserInteractionEnabled = true
            cell.addShadow(color: .black, offSet: CGSize(width: 0, height: 5), radius: 10, opacity: 0.05)
        }
        
        collectionManager.headerStyler = {(headerView, section, index) in
            headerView.titleLabel.text = "Header"
        }
        
        collectionManager.footerStyler = { (footerView, section, index)in
            footerView.titleLabel.text = "Footer"
        }
        
        tableManager.configure(tableView: tableView) { (cell, model, indexPath) in
            cell.textLabel?.text = model
        }
        
        tableManager.headerStyler = { (headerView, section, index) in
            headerView.titleLabel.text = "Header"
            headerView.titleLabel.isUserInteractionEnabled = true
        }
        
        tableManager.footerStyler = { (footerView, section, index) in
            footerView.titleLabel.text = "Footer"
        }
        
        tableManager.update(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"], ["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        collectionManager.update(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.clipEdges(exclude: [.bottom])
        tableView.clipBottom(to: .centerY)
        collectionView.clipTop(to: .centerY)
        collectionView.clipEdges(exclude: [.top])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let button = SFButton()
        button.title = "Hola"
        let alert = SFAlertViewController(title: "Prueba", message: "Este es un mensaje de prueba", buttons: [button], automaticallyAdjustsColorStyle: true)
        present(alert, animated: true)
    }
}















































