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
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero, style: UITableViewStyle = .plain) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame, style: style)
        updateColors()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateRow(with action: SFTableCellAction, indexPath: IndexPath, newIndexPath: IndexPath? = nil, animation: UITableViewRowAnimation) {
        beginUpdates()
        switch action {
        case .delete: deleteRows(at: [indexPath], with: animation)
        case .insert: insertRows(at: [indexPath], with: animation)
        case .reload: reloadRows(at: [indexPath], with: animation)
        case .move:
            guard let newIndexPath = newIndexPath else { return }
            moveRow(at: indexPath, to: newIndexPath)
        }
        endUpdates()
    }
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColor() : colorStyle.getMainColor()
        separatorColor = colorStyle.getSeparatorColor()
        updateSubviewsColors()
        
        // This is going to loop through every section inside the table node and reload it with the correct color style on the main thread
        if self.numberOfSections >= 0 {
            let numberOfSections = self.numberOfSections - 1
            if numberOfSections >= 0 {
                for i in 0...numberOfSections {
                    if let headerCell = headerView(forSection: i) as? SFViewColorStyle {
                        headerCell.updateColors()
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





















