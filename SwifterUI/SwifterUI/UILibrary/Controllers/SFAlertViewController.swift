//
//  SFAlertViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/08/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

open class SFAlertViewController: SFBulletinViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        bulletinView.closeButton.isHidden = true
    }
    
}
