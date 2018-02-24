//
//  SFColorStyleProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 12/06/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

// minimumBrighness: Global variable to indicate minimum level of brightness for dark mode
public var minimumBrighness: CGFloat = 0.30

public protocol SFColorStyleProtocol {
    
    // MARK: - Instance Properties
    
    // automaticallyAdjustsColorStyle: This property enables automatic change between light and dark mode
    var automaticallyAdjustsColorStyle: Bool { get set }
    
    // colorStyle: Indicates the current color style of your view controller
    var colorStyle: SFColorStyle { get }
    
    // MARK: - Instance Methods
    
    // updateColors: This method should update the UI based on the current colorStyle, every FluidNode and FluidNodeController that needs darkmode should implement this method to set the different colors.
    // For convenience, every colorStyle provides some default(black and white) colors but you can implement whatever you need with a switch statement
    func updateColors()
    
    // updateSubNodesColors: Update subnodes colors automatically, you just have to call it at the end of updateColors() to work
    func updateSubviewsColors()
}

public extension SFColorStyleProtocol {
    
    // MARK: - Instance Properties
    
    public var colorStyle: SFColorStyle {
        return UIScreen.main.brightness > minimumBrighness ? .light : .dark
    }
    
}
