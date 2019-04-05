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
    
    open lazy var popView: SFPopView = {
        let popView = SFPopView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, middleView: SFView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle))
        return popView
    }()
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        view.addSubview(popView)
        super.viewWillPrepareSubViews()
    }
    
    open override func viewWillSetConstraints() {
        popView.clipSides(useSafeArea: false)
        super.viewWillSetConstraints()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateAppear()
    }

    private func animateAppear() {
        popView.contentView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        let animator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
        animator.addAnimations {
            self.popView.contentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        animator.startAnimation()
    }
    
    public func animateDisappear(completion: (() -> Void)? = nil) {
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
