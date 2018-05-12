//
//  SFAlertViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 08/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFAlertViewController: SFViewController, SFInteractionViewController {
    
    // MARK: - Instance Properties
    
    public final var mainView: UIView { return alertView.backgroundView }
    
    public final let alertView: SFAlertView
    
    public final lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: view)
    public final var snapping: UISnapBehavior?
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, title: String, message: String, buttons: [SFButton]) {
        alertView = SFAlertView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, title: title, message: message, buttons: buttons)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        buttons.forEach { (button) in
            button.addTarget(self, action: #selector(didTouch(button:)), for: .touchUpInside)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(alertView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView))
        alertView.backgroundView.addGestureRecognizer(panGesture)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        alertView.clipTop(to: .top, useSafeArea: false)
        alertView.clipEdges(exclude: [.top])
        snapping = UISnapBehavior(item: alertView.backgroundView, snapTo: view.center)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let animation = SFScaleAnimation(with: alertView.backgroundView, type: .inside)
        animation.duration = 1.0
        animation.damping = 0.7
        animation.velocity = 0.8
        animation.start()
        updateColors()
    }
    
    @objc private func didTouch(button: SFButton) {
        handleTouch(button: button)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let snapping = snapping else { return }
        animator.removeBehavior(snapping)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc private func dragView(recognizer: UIPanGestureRecognizer) {
        moveView(recognizer: recognizer)
    }
    
    open override func updateColors() {
        super.updateColors()
        DispatchQueue.addAsyncTask(to: .main) {
            UIView.animate(withDuration: 0.6, animations: {
                self.view.backgroundColor = .clear
            })
        }
    }
    
}
























