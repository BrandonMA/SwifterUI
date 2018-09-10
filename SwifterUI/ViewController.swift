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
    
    lazy var button: SFFluidButton = {
        var button = SFFluidButton()
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
        
        tableView.clipSides(exclude: [.bottom])
        tableView.clipBottom(to: .top, of: button)
        
        button.height(SFDimension(value: 52))
        button.width(SFDimension(value: 52))
        button.center()
        
        collectionView.clipTop(to: .bottom, of: button)
        collectionView.clipSides(exclude: [.top])
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
        backgroundView.clipSides()
        
        tableManager.updateSections(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        collectionManager.updateSections(data: [["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        
        backgroundView.button.addAction {
            print("Hola")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.delay(by: 2, dispatchLevel: .main) {
            self.tableManager.updateSections(data: [["Prueba 1", "Prueba 2"], ["Prueba 1", "Prueba 2", "Prueba 3", "Prueba 1", "Prueba 2", "Prueba 3", "Prueba 4"]])
        }
        
        let button = SFFluidButton()
        button.title = "Hola"
        button.addAction {
            print("Hola")
        }
        let alert = SFAlertViewController(title: "Prueba", message: "Hola este es mi mensaje", buttons: [button])
        present(alert, animated: true)
    }
}







































