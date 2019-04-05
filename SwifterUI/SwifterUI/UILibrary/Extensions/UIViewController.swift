//
//  UIViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 24/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIViewController {

    // MARK: - Instance Methods

    final func showError(title: String? = nil, message: String? = nil) {
        let errorTitle = title ?? "Error"
        let errorMessage = message ?? "Ocurrio un problema, intente de nuevo por favor"
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
