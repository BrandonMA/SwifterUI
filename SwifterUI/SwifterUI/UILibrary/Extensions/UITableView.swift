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
    
    public final func scrollToBottom(animated: Bool = true) {
        let lastSection = numberOfSections - 1
        if lastSection >= 0 {
            let lastRow = numberOfRows(inSection: lastSection) - 1
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            if lastRow >= 0 {
                scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}

