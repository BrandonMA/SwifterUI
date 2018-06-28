//
//  SFTabBarItem.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 28/06/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTabBarItem: UITabBarItem {
    
    public enum SFTabBarAnimation {
        case none
        case shake
        case morph
        case squeeze
        case wobble
        case flip
        case rotate
    }
    
    open var animation: SFTabBarAnimation = .none
    
    open func startAnimation() {
        if let view = value(forKey: "view") as? UIView {
            let imageView = view.subviews[0]
            switch animation {
            case .none: return
            case .shake: SFShakeAnimation(with: imageView).start()
            case .morph: SFMorphAnimation(with: imageView).start()
            case .squeeze: SFSqueezeAnimation(with: imageView).start()
            case .wobble: SFWobbleAnimation(with: imageView).start()
            case .flip: SFFlipAnimation(with: imageView).start()
            case .rotate: SFRotationAnimation(with: imageView).start()
            }
        }
    }
    
}

