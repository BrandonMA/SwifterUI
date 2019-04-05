//
//  CGPoint.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/19/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
}
