//
//  SFPresentationManager.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/01/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public enum SFPresentationType: String {
    case pop
}

open class SFPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Instance Properties
    
    open var animation: SFPresentationType
    
    // MARK: - Initializers
    
    // Initialize your SFPresentationManager with an specific animation
    public init(animation: SFPresentationType) {
        self.animation = animation
        super.init()
    }
    
    // MARK: - Instance Methods
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch self.animation {
        case .pop:
            return SFPopPresentation(presentedViewController: presented, presenting: presenting)
        }
    }
}
