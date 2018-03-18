//
//  SFChatView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFChatView: SFView {
    
    // MARK: - Instance Properties
    
    open lazy var tableView: SFTableView = {
        let tableView = SFTableView(automaticallyAdjustsColorStyle: true, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SFTableViewChatCell.self, forCellReuseIdentifier: SFTableViewChatCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.useAlternativeColors = true
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool, frame: CGRect) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(tableView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        tableView.clipEdges()
    }
    
}

