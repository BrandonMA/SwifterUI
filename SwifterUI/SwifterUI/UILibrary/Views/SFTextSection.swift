//
//  SFTextSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFTextSection: SFSection {
    
    // MARK: - Instance Properties
    
    public final var textField: SFTextField {
        return bottomView as! SFTextField
    }
    
    public final var usePickerMode: Bool = false {
        didSet {
            if usePickerMode {
                textField.rightImage = SFAssets.imageOfArrowRight.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    public override var useAlternativeColors: Bool {
        didSet {
            textField.useAlternativeColors = useAlternativeColors
        }
    }
    
    public override final var text: String? {
        guard let text = textField.text else {
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
        let textField = SFTextField(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.leftPadding = 8
        textField.rightPadding = 8
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame, bottomView: textField)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
}






