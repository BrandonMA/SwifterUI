//
//  SFDimension.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public struct SFDimension {
    
    public var type: SFDimensionType
    public var value: CGFloat
    public static var zero: SFDimension = SFDimension(value: 0)
    
    public enum SFDimensionType {
        case point
        case fraction
    }
    
    public init(type: SFDimensionType = .point, value: CGFloat) {
        self.type = type
        self.value = value
    }
}
