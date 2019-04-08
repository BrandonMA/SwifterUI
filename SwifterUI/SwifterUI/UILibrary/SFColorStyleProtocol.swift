//
//  SFColorStyleProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 12/06/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

/**
 Indicate minimum level of brightness for dark 
 public func updateColors() {
 <#code#>
 }
 
 public func updateColors() {
 <#code#>
 }
 mode
 */
public var minimumBrighness: CGFloat = 0.3

/**
 SFColorStyleProtocol is adopted by an object that is capable of adapting it's color depending on current brightness
 */
public protocol SFColorStyleProtocol {

    // MARK: - Instance Properties

    /**
     Enables automatic change between light and dark mode
     */
    var automaticallyAdjustsColorStyle: Bool { get set }
    
    /**
     Represent current color palette that must be used
     */
    var colorStyle: SFColorStyle { get }

    // MARK: - Instance Methods

    /**
     Update current color depending on colorStyle
     */
    func updateColors()

    /**
     Call updateColors for all subviews
     */
    func updateSubviewsColors()
}

public extension SFColorStyleProtocol {

    // MARK: - Instance Properties

    var colorStyle: SFColorStyle { return UIScreen.main.brightness >= minimumBrighness ? .light : .dark }

}
