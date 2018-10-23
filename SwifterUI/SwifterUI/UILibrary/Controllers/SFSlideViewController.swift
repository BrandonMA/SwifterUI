//
//  SFPopViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/01/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSlideViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    private var initialPoint: CGFloat = 0
    
    open lazy var slideView: SFSlideView = {
        let slideView = SFSlideView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        slideView.translatesAutoresizingMaskIntoConstraints = false
        return slideView
    }()
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        view.addSubview(slideView)
        slideView.bar.dismissButton.addTarget(self, action: #selector(dismissPop), for: .touchUpInside)
        super.viewWillPrepareSubViews()
    }
    
    open override func viewWillSetConstraints() {
        slideView.clipSides(useSafeArea: false)
        super.viewWillSetConstraints()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        self.sfview.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dismiss(withPanGesture:))))
    }
    
    @objc public final func dismissPop() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc public final func dismiss(withPanGesture panGesture: UIPanGestureRecognizer) {
        
        guard let window = UIApplication.shared.keyWindow else { fatalError() }
        let currentPoint = panGesture.location(in: window).y
        
        if panGesture.state == .began {
            initialPoint = panGesture.location(in: window).y
        } else if panGesture.state == .changed {
            let distance = currentPoint - initialPoint
            view.frame.origin.y += distance
            initialPoint = currentPoint
        } else if panGesture.state == .ended {
            if view.frame.origin.y < 80 {
                UIView.animate(withDuration: 0.6,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0,
                               options: [],
                               animations: {
                    self.view.frame.origin.y = UIApplication.shared.statusBarFrame.height + 10
                }, completion: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

