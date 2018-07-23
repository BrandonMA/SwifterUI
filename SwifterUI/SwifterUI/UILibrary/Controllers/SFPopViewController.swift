//
//  SFPopViewController.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 22/01/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    private var initialPoint: CGFloat = 0
    
    open lazy var popView: SFPopView = {
        let popView = SFPopView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        popView.translatesAutoresizingMaskIntoConstraints = false
        return popView
    }()
    
    // MARK: - Instance Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(popView)
        view.clipsToBounds = true
        popView.bar.dismissButton.addTarget(self, action: #selector(dismissPop), for: .touchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismiss(withPanGesture:)))
        self.sfview.addGestureRecognizer(panGesture)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        popView.clipEdges(useSafeArea: false)
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

