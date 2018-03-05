//
//  SFNotificationIndicator.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFNotificationIndicator: SFView {
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    open override func updateColors() {
        backgroundColor = colorStyle.getInteractiveColor()
        updateSubviewsColors()
    }
    
}
