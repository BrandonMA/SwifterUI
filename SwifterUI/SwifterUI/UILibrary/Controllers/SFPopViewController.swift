//
//  SFPopViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/09/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open var popView: SFPopView
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true) {
        popView = SFPopView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, middleView: SFView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle))
        popView.translatesAutoresizingMaskIntoConstraints = false
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(popView)
        popView.clipSides(useSafeArea: false)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        popView.contentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        let animator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
        
        animator.addAnimations {
            self.popView.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        animator.startAnimation()
    }
    
    public func returnToMainViewController(completion: (() -> Void)? = nil) {
        
        let animator = UIViewPropertyAnimator(damping: 1.0, response: 0.4)
        
        animator.addAnimations {
            self.popView.contentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
        
        animator.addCompletion { (_) in
            self.dismiss(animated: true, completion: completion)
        }
        
        animator.startAnimation()
    }
}
