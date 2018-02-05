//
//  SFScaleAnimation.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFScaleAnimation: SFZoomAnimation {
    
    // MARK: - Instance Methods
    
    open override func load() {
        guard let view = self.view else { return }
        initialScaleX = type == .inside ? 0.01 : 1.0
        initialScaleY = type == .inside ? 0.01 : 1.0
        finalScaleX = type == .inside ? 1.0 : 0.01
        finalScaleY = type == .inside ? 1.0 : 0.01
        initialAlpha = type == .inside ? 0.0 : 1.0
        finalAlpha = type == .inside ? 1.0 : 0.0
        initialFrame = view.frame
        view.transform = CGAffineTransform(scaleX: initialScaleX, y: initialScaleY)
    }
}
