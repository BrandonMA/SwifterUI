//
//  UIImageView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func download(from url: String, completion: ((Bool) -> Void)? = nil ) {
        UIImage.download(from: url) { (image) in
            DispatchQueue.addAsyncTask(to: .main, handler: {
                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { self.image = image }, completion: completion)
            })
        }
    }
}
