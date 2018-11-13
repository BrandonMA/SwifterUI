//
//  SFTableView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public enum SFTableCellAction {
    case delete
    case insert
    case reload
    case move
}

open class SFTableView: UITableView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, style: UITableView.Style = .plain) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        tintColor = colorStyle.interactiveColor
        backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        reloadData()
        separatorColor = colorStyle.separatorColor
        updateSubviewsColors()
        
        // This is going to loop through every section inside the table node and reload it with the correct color style on the main thread
        if self.numberOfSections >= 0 {
            let numberOfSections = self.numberOfSections - 1
            if numberOfSections >= 0 {
                for i in 0...numberOfSections {
                    
                    if let headerView = headerView(forSection: i) as? SFViewColorStyle {
                        headerView.updateColors()
                    }
                    
                    if let footerView = footerView(forSection: i) as? SFViewColorStyle {
                        footerView.updateColors()
                    }
                    
                    let numberOfRows = self.numberOfRows(inSection: i) - 1
                    if numberOfRows > 0 {
                        for j in 0...numberOfRows {
                            guard let cell = cellForRow(at: IndexPath(row: j, section: i)) as? SFTableViewCell else { return }
                            cell.updateColors()
                        }
                    }
                }
            }
        }
    }
    
    open override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? SFTableViewCell {
            cell.updateColors()
        }
        return cell
    }
    
}
