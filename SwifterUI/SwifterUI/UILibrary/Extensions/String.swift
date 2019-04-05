//
//  String.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 14/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension String {

    // MARK: - Instance Methods

    func estimatedFrame(with font: UIFont, maxWidth: CGFloat) -> CGRect {
        let size = CGSize(width: maxWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
    }
}
