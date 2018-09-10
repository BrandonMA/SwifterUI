//
//  SFAlertViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/08/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

open class SFAlertViewController: SFBulletinViewController {
    
    public init(title: String = "", message: String = "", buttons: [SFFluidButton], automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        bulletinTitle = title
        bulletinMessage = message
        useDatePicker = false
        useButtons = true
        buttons.forEach { (button) in
            let oldActions = button.touchActions
            button.touchActions.removeAll()
            button.insertAction({ [unowned self] in
                self.returnToMainViewController(completion: {
                    oldActions.forEach({ $0() })
                })
                }, at: 0)
        }
        createBulletinView()
        bulletinView.closeButton.isHidden = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
