//
//  UIFontExtensions.swift
//  Fluid-UI-Framework
//
//  Created by Brandon Maldonado Alonso on 11/06/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIFont {

    // MARK: - Static Properties

    static var systemFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    static var boldSystemFont: UIFont {
        return UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }

}
