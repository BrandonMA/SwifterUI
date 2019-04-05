//
//  UIColorExtensions.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/08/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIColor {

    // MARK: - Initializers

    // init: Instead of the init method provided by apple that takes values between 1 and 0, this one use 255-0.
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, transparency: CGFloat = 1) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: transparency)
    }

    convenience init(hex: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xff0000) >> 16),
                  green: CGFloat((rgbValue & 0xff00) >> 8),
                  blue: CGFloat(rgbValue & 0xff),
                  transparency: alpha)
    }

    // MARK: - Static Methods

    // hexValue: You need to provide 255 values to use this function
    static func getHexValue(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        return String(format: "%02X", Int(red)) +
            String(format: "%02X", Int(green)) +
            String(format: "%02X", Int(blue))
    }

    // MARK: - Instance Properties

    var redComponent: CGFloat {
        var red: CGFloat = 0
        self.getRed(&red, green: nil, blue: nil, alpha: nil)
        return red * 255
    }

    var greenComponent: CGFloat {
        var green: CGFloat = 0
        self.getRed(nil, green: &green, blue: nil, alpha: nil)
        return green * 255
    }

    var blueComponent: CGFloat {
        var blue: CGFloat = 0
        self.getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue * 255
    }
}
