//
//  SFTableView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableView: UITableView, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, style: UITableViewStyle = .plain) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: .zero, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = useAlternativeColors == true ? colorStyle.getAlternativeColors() : colorStyle.getMainColor()
        separatorColor = colorStyle.getSeparatorColor()
        updateSubviewsColors()
        
        // This is going to loop through every section inside the table node and reload it with the correct color style on the main thread
        if self.numberOfSections > 0 {
            for i in 0...self.numberOfSections - 1 {
                for j in 0...self.numberOfRows(inSection: i) {
                    
                    guard let cell = cellForRow(at: IndexPath(row: j, section: i)) as? SFTableViewCell else { return }
                    cell.updateColors()
                }
            }
        }
    }
    
}
