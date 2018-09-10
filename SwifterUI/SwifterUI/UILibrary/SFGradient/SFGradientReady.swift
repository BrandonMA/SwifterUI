//
//  SFGradientReady.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFGradientReady {
    
    // MARK: - Instance Methods
    
    func setGradient(_ gradient: SFGradient)
    
}

extension UIView: SFGradientReady {
    
    // MARK: - Instance Methods
    
    public func setGradient(_ gradient: SFGradient) {
        if self.frame.width != 0 && self.frame.height != 0 {
            let gradientLayer = gradient.getGradientLayer(width: self.frame.width, height: self.frame.height)
            if let layer = self.layer.sublayers?[0] {
                if layer.isKind(of: CAGradientLayer.self) {
                    self.layer.replaceSublayer(layer, with: gradientLayer)
                } else {
                    self.layer.insertSublayer(gradientLayer, at: 0)
                }
            } else {
                self.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
    }
}
