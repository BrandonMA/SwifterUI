//
//  SFControllerProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 28/08/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFControllerColorStyle: SFColorStyleProtocol {
    
    // MARK: - Instance Properties
        
    // statusBarStyle: This enables preferredStatusBarStyle changes on the go, without needing to
    var statusBarStyle: UIStatusBarStyle { get set }
    
    // automaticallyTintNavigationBar: This should be set the same as automaticallyAdjustsColorStyle when initializing, but you can disable it so navigation bar color is not changed
    var automaticallyTintNavigationBar: Bool { get set }
    
    // MARK: - Instance Methods
        
    func checkColorStyle()
    
    func checkColorStyleListener()
    
}

public extension SFControllerColorStyle where Self: UIViewController {
    
    public func checkColorStyle() {
        if automaticallyAdjustsColorStyle == true {
            self.updateColors()
            checkColorStyleListener()
        }
    }
    
    public func updateSubviewsColors() {
        if let view = self.view as? SFViewColorStyle {
            view.updateColors()
        }
    }
    
}





