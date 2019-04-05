//
//  UITableView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 14/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UITableView {
    
    // MARK: - Instance Methods
    
    final func scrollToBottom(animated: Bool = true) {
        let lastSection = numberOfSections - 1
        if lastSection >= 0 {
            let lastRow = numberOfRows(inSection: lastSection) - 1
            if lastRow >= 0 {
                let indexPath = IndexPath(row: lastRow, section: lastSection)
                scrollToRow(at: indexPath, at: .middle, animated: animated)
            }
        }
    }
    
    func cellForSubview(_ subview: UIView) -> UITableViewCell? {
        var superview = subview.superview
        
        while superview != nil {
            if superview is UITableViewCell {
                return superview as? UITableViewCell
            }
            
            superview = superview?.superview
        }
        
        return nil
    }
    
    func indexPathForSubview(_ subview: UIView) -> IndexPath? {
        if let cell = cellForSubview(subview) {
            return indexPath(for: cell)
        }
        return nil
    }
}

