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
    
    open var slideView: SFSlideView
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool) {
        slideView = SFSlideView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        slideView.translatesAutoresizingMaskIntoConstraints = false
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slideView)
        slideView.clipSides(useSafeArea: false)
        view.clipsToBounds = true
        slideView.bar.dismissButton.addTarget(self, action: #selector(dismissPop), for: .touchUpInside)
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
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                    self.view.frame.origin.y = UIApplication.shared.statusBarFrame.height + 10
                }, completion: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

