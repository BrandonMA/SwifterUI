//
//  UIView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIView {

    // MARK: - Instance Properties

    final var useCompactInterface: Bool {
        return self.traitCollection.horizontalSizeClass == .compact || self.traitCollection.verticalSizeClass == .compact
    }

    // MARK: - Instance Methods

    final func addShadow(color: UIColor, offSet: CGSize, radius: CGFloat, opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
