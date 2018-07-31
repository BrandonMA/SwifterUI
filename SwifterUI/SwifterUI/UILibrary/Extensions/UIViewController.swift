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

    public final func showError(title: String? = nil, message: String? = nil) {
        let errorTitle = title ?? "Error"
        let errorMessage = message ?? "Ocurrio un problema, intente de nuevo por favor"
        let button = SFButton()
        button.setTitle("Entendido", for: .normal)
        let alert = SFBulletinViewController(title: errorTitle, message: errorMessage, buttons: [button])
        self.present(alert, animated: true)
    }
}
