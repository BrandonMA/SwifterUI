//
//  SFSignViewTextField.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSignViewTextField: SFTextField {
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        autocorrectionType = .no
        leftPadding = 12
        layer.cornerRadius = 10
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

