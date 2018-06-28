//
//  SFTextScrollSection
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFTextScrollSection: SFSection {
    
    // MARK: - Instance Properties
    
    public final var textView: SFTextView {
        return bottomView as! SFTextView
    }
    
    public override var useAlternativeColors: Bool {
        didSet {
            textView.useAlternativeColors = useAlternativeColors
        }
    }
    
    public override final var text: String? {
        guard let text = textView.text else {
            SFWobbleAnimation(with: self).start()
            return nil
        }
        
        if text != "" {
            return text
        } else {
            SFWobbleAnimation(with: self).start()
            return nil
        }
    }
    
    // MARK: - Initializer
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        let textView = SFTextView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame, bottomView: textView)
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
}






