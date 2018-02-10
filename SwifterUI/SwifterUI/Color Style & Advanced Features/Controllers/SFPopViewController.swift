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
    
    override var sfview: SFPopView {
        return view as! SFPopView
    }
    
    // MARK: - Instance Methods
    
    open override func loadView() {
        self.view = SFPopView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        sfview.bar.tintColor = .blue
        sfview.bar.dismissButton.setImage(UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sfview.bar.dismissButton.addTarget(self, action: #selector(dismissPop), for: .touchUpInside)
        sfview.bar.titleLabel.text = "Prueba"
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismiss(withPanGesture:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc private func dismissPop() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismiss(withPanGesture panGesture: UIPanGestureRecognizer) {
        
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
                    self.view.frame.origin.y = 30
                }, completion: nil)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
