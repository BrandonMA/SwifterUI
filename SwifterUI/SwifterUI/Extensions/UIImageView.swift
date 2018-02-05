//
//  UIImageView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func download(from url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.addAsyncTask(to: .main, handler: {
                guard let image = UIImage(data: data) else { return }
                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { self.image = image }, completion: nil)
            })
            }.resume()
    }
}
