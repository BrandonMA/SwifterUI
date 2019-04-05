//
//  SFLayoutView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 09/08/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

public protocol SFLayoutView {
    
    // MARK: - Instance Properties
    
    /**
     Use it to save custom constraints and not setting them every time update constraints is called
     */
    var customConstraints: Constraints { get set }
    
    // MARK: - Instance Methods
    
    /**
     Called before setConstraints(), use it to add all your subviews and customization.
     */
    func prepareSubviews()
    
    /**
     Called after prepareSubviews(), use to set custom constraints, this method is called only once,
     in case you need to update your constraints do it in updateConstraints()
     */
    func setConstraints()
    
}
