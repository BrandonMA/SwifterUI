//
//  ViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

class Model {
    let names = SFDataManager<String>()
    
    init() {
        names.update(data: [["Brandon", "Maldonado", "Alonso"], ["Jula"], ["Celina"]])
        
        DispatchQueue.delay(by: 3, dispatchLevel: .main) {
            self.names.update(data: [["Celina"], ["Jula"], ["Brandon", "Maldonado", "Alonso"]])
        }
    }
    
}

class View: SFView {
    
    lazy var tableView: SFTableView = {
        let view = SFTableView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func prepareSubviews() {
        addSubview(tableView)
        super.prepareSubviews()
    }
    
    override func setConstraints() {
        tableView.clipSides()
        super.setConstraints()
    }
    
}

class ViewController: SFViewController, SFVideoPlayerDelegate {
    
    let model = Model()
    
    let adapter = SFTableAdapter<String, SFTableViewCell, SFTableViewHeaderView, SFTableViewFooterView>()
    
    lazy var backgroundView: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        backgroundView.clipSides()
        
        adapter.configure(tableView: backgroundView.tableView, dataManager: model.names)
        adapter.delegate = self
    }
}

extension ViewController: SFTableAdapterDelegate {
    
    var useCustomHeader: Bool { return true }
    
    func prepareHeader<DataType>(_ view: SFTableViewHeaderView, with data: SFDataSection<DataType>, index: Int) where DataType: Hashable {
        view.textLabel?.text = "Prueba - \(index)"
    }
    
    func prepareCell<DataType>(_ cell: SFTableViewCell, at indexPath: IndexPath, with data: DataType) where DataType: Hashable {
        guard let name = data as? String else { return }
        cell.textLabel?.text = name
    }
    
}
