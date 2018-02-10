//
//  UITextField.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UITextField {
    
    public func setMargin(left: CGFloat?, right: CGFloat?) {
        
        if let left = left {
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.bounds.height))
            self.leftView = leftView
            leftViewMode = .always
        }
        
        if let right = right {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.bounds.height))
            self.rightView = rightView
            rightViewMode = .always
        }
        
    }
}
