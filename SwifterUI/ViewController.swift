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

class View: SFView {
    
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
    
    lazy var button: SFForceTouchButton = {
        var button = SFForceTouchButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "9"
        button.layer.cornerRadius = 26
        return button
    }()
    
    override func prepareSubviews() {
        addSubview(tableView)
        addSubview(collectionView)
        addSubview(button)
        super.prepareSubviews()
    }
    
    override func setConstraints() {
        
        tableView.clipEdges(exclude: [.bottom])
        tableView.clipBottom(to: .top, of: button)
        
        button.height(SFDimension(value: 52))
        button.width(SFDimension(value: 52))
        button.center()
        
        collectionView.clipTop(to: .bottom, of: button)
        collectionView.clipEdges(exclude: [.top])
        super.setConstraints()
    }
    
}

class ViewController: SFViewController {
    
    lazy var backgroundView: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableManager: SFTableManager<String, SFTableViewCell, SFTableViewHeaderView, SFTableViewFooterView> = {
        let tableManager = SFTableManager<String, SFTableViewCell, SFTableViewHeaderView, SFTableViewFooterView>()
        
        tableManager.configure(tableView: backgroundView.tableView) { (cell, model, indexPath) in
            cell.textLabel?.text = model
        }
        
        tableManager.headerStyler = { (headerView, section, index) in
            headerView.titleLabel.text = "Header"
            headerView.titleLabel.isUserInteractionEnabled = true
        }
        
        tableManager.footerStyler = { (footerView, section, index) in
            footerView.titleLabel.text = "Footer"
        }
        
        return tableManager
    }()
    
    lazy var collectionManager: SFCollectionManager<String, SFCollectionViewCell, SFCollectionViewHeaderView, SFCollectionViewFooterView> = {
        let collectionManager = SFCollectionManager<String, SFCollectionViewCell, SFCollectionViewHeaderView, SFCollectionViewFooterView>()
        
        collectionManager.configure(collectionView: backgroundView.collectionView) { (cell, model, indexPath) in
            cell.isUserInteractionEnabled = true
            cell.addShadow(color: .black, offSet: CGSize(width: 0, height: 5), radius: 10, opacity: 0.05)
        }
        
        collectionManager.headerStyler = {(headerView, section, index) in
            headerView.titleLabel.text = "Header"
        }
        
        collectionManager.footerStyler = { (footerView, section, index)in
            footerView.titleLabel.text = "Footer"
        }
        
        return collectionManager
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        backgroundView.clipEdges()
        
        tableManager.updateSections(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        collectionManager.updateSections(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        
        backgroundView.button.addAction { [unowned self] in
            if self.backgroundView.button.isOn {
                print("Hola")
            } else {
                print("Adios")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.delay(by: 2, dispatchLevel: .main) {
            self.tableManager.updateSections(data: [["Prueba 1", "Prueba 2"], ["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        }
    }
}







//struct FirebaseMessage: SFMessage {
//
//    // MARK: - Static Methods
//
//    public static func == (lhs: FirebaseMessage, rhs: FirebaseMessage) -> Bool {
//        return lhs.identifier == rhs.identifier
//    }
//
//    // MARK: - Instance Properties
//
//    var identifier: String = ""
//    var senderIdentifier: String = ""
//    var text: String?
//    var imageURL: URL?
//    var image: UIImage?
//    var videoURL: URL?
//    var fileURL: URL?
//    var timestamp: Date = Date()
//    var isMine: Bool = true
//
//    // MARK: - Initializers
//
//    public init(senderIdentifier: String, text: String? = nil, image: UIImage? = nil, videoURL: URL? = nil, fileURL: URL? = nil, timestamp: Date, isMine: Bool) {
//        self.identifier = UUID().uuidString
//        self.senderIdentifier = senderIdentifier
//        self.text = text
//        self.image = image
//        self.imageURL = nil
//        self.videoURL = videoURL
//        self.fileURL = fileURL
//        self.timestamp = timestamp
//        self.isMine = isMine
//    }
//
//}







































