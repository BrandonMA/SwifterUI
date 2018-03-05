//
//  UIImageExtensions.swift
//  Fluid-UI-Framework
//
//  Created by Brandon Maldonado Alonso on 16/07/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIImage {
    
    // MARK: - Static Methods
    
    public static func download(from url: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
            }.resume()
    }
    
    // MARK: - Instance Methods
    
    public func tint(color: UIColor, alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)
        
        context.setFillColor(color.cgColor)
        context.setBlendMode(CGBlendMode.sourceIn)
        context.setAlpha(alpha)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.fill(rect)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
    
    public func tint(color: UIColor, alpha: CGFloat, handler: @escaping (UIImage?) -> ()) {
        DispatchQueue.addAsyncTask(to: .background) {
            handler(self.tint(color: color, alpha: alpha))
        }
    }
    
}
