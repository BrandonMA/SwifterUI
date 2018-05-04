//
//  UIImageExtensions.swift
//  Fluid-UI-Framework
//
//  Created by Brandon Maldonado Alonso on 16/07/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

public extension UIImage {
    
    public func download(from url: URL?) -> Promise<UIImage> {
        return Promise { seal in
            guard let url = url else { return }
            URLSession.shared.dataTask(.promise, with: url).compactMap{ UIImage(data: $0.data) }.done({ image in
                DispatchQueue.addAsyncTask(to: .main, handler: {
                    seal.fulfill(image)
                })
            }).catch { (error) in
                seal.reject(error)
            }
        }
    }
}
