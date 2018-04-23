//
//  UIImageView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func setImage(from url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(.promise, with: url).compactMap{ UIImage(data: $0.data) }.done({ image in
            DispatchQueue.addAsyncTask(to: .main, handler: {
                self.image = image
            })
        }).catch { (error) in
            print(error.localizedDescription)
        }
    }
    
}
