//
//  SFButtonSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 27/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFButtonSection: SFSection {
    
    // MARK: - Instance Properties
    
    public final var placeholder: String = "" {
        didSet {
            button.useAlternativeTextColor = true
            button.setTitle(placeholder, for: .normal)
            updateColors()
        }
    }
    
    public final var title: String = "" {
        didSet {
            button.useAlternativeTextColor = false
            button.setTitle(title, for: .normal)
            updateColors()
        }
    }
    
    public final var button: SFButton {
        return bottomView as! SFButton
    }
    
    public override var useAlternativeColors: Bool {
        didSet {
            button.isTextPicker = useAlternativeColors
        }
    }
    
    public override final var text: String? {
        if title != "" {
            return title
        } else {
            SFWobbleAnimation(with: self).start()
            return nil
        }
    }
    
    // MARK: - Initializer
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        let button = SFButton(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        button.rightImageView.image = SFAssets.imageOfArrowRight.withRenderingMode(.alwaysTemplate)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame, bottomView: button)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
}












