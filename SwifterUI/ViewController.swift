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
    
    let tableManager = SFTableManager<String, SFTableViewCell, SFTableViewHeaderView, SFTableViewFooterView>(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"], ["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
    let collectionManager = SFCollectionManager<String, SFCollectionViewCell, SFCollectionViewHeaderView, SFCollectionViewFooterView>(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        collectionManager.configure(collectionView: collectionView) { (cell, model, indexPath) in
            cell.addShadow(color: .black, offSet: CGSize(width: 0, height: 5), radius: 10, opacity: 0.05)
        }
        
        collectionManager.headerStyle = {(headerView, section, index) in
            headerView.titleLabel.text = "Header"
        }
        
        collectionManager.footerStyle = { (footerView, section, index)in
            footerView.titleLabel.text = "Footer"
        }
        
        tableManager.configure(tableView: tableView) { (cell, model, indexPath) in
            cell.textLabel?.text = model
        }
        
        tableManager.headerStyle = { (headerView, section, index) in
            headerView.titleLabel.text = "Header"
        }
        
        tableManager.footerStyle = { (footerView, section, index) in
            footerView.titleLabel.text = "Footer"
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
    }
}















































