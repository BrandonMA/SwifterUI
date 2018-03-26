//
//  SFBubbleView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFBubbleView: SFView {

    // MARK: - Instance Methods

    open override func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getInteractiveColor() : colorStyle.getMainColor()
        updateSubviewsColors()
    }

}
