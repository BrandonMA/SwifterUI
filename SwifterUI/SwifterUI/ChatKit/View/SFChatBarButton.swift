//
//  SFChatBarButton.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

public final class SFChatBarButton: SFFluidButton {
    
    // MARK: - Instance Methods
    
    public override func updateColors() {
        backgroundColor = colorStyle.getInteractiveColor()
        normalColor = backgroundColor
        tintColor = colorStyle.getMainColor()
        textColor = colorStyle.getMainColor()
        highlightedColor = colorStyle.getMainColor()
        highlightedTextColor = colorStyle.getInteractiveColor()
    }
    
}
