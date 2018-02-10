//
//  SFTextSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTextSection: SFSection {
    
    public var textField: SFTextField {
        return bottomView as! SFTextField
    }
    
    open var usePickerMode: Bool = false
    
    open override lazy var bottomView: UIView = {
        let textField = SFTextField(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.leftPadding = 8
        textField.rightPadding = 8
        if usePickerMode == true {
            textField.rightImage = UIImage(named: "rightArrow")
        }
        return textField
    }()
    
}








