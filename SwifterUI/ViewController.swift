//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

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
        layout.sectionInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
    lazy var collectionView: SFCollectionView = {
        let collectionView = SFCollectionView(collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let tableManager = SFTableManager<String, SFTableViewCell>(data: [["Prueba 1"]])
    let collectionManager = SFCollectionManager<String, SFCollectionViewCell>(data: [["Prueba 1"]])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(collectionView)
        collectionManager.configure(collectionView: collectionView)
        collectionManager.cellHandler = { (cell, model, indexPath) in
            cell.addShadow(color: .black, offSet: CGSize(width: 10, height: 10), radius: 10, opacity: 0.20)
        }
        tableManager.configure(tableView: tableView)
        tableManager.cellHandler = { (cell, model, indexPath) in
            cell.textLabel?.text = model
        }
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
        DispatchQueue.delay(by: 2, dispatchLevel: .main) {
            
            self.tableManager.update(data: [["Prueba 1", "Prueba 2"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"]], animation: .left)
            
            self.collectionManager.update(data: [["Prueba 1", "Prueba 2"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"], ["Prueba 1", "Prueba 2", "Prueba 3"]])
        }
    }
}


















































