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
        backgroundColor = colorStyle.interactiveColor
        normalColor = backgroundColor
        tintColor = colorStyle.mainColor
        textColor = colorStyle.mainColor
        highlightedColor = colorStyle.mainColor
        highlightedTextColor = colorStyle.interactiveColor
    }
    
}
