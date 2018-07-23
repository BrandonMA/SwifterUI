//
//  SFButton.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFButton: UIButton, SFViewColorStyle {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    open var setTextColor: Bool = true
    
    open var useAlternativeTextColor: Bool = false
    
    open var useClearBackground: Bool = false
    
    open var isTextPicker: Bool = false
    
    public final var addTouchAnimations: Bool = false {
        didSet {
            if addTouchAnimations == true {
                addTarget(self, action: #selector(animateTouchDown(button:)), for: .touchDown)
                addTarget(self, action: #selector(touchUp(button:)), for: .touchUpInside)
                addTarget(self, action: #selector(touchUp(button:)), for: .touchDragExit)
            } else {
                removeTarget(self, action: #selector(animateTouchDown(button:)), for: .touchDown)
                removeTarget(self, action: #selector(touchUp(button:)), for: .touchUpInside)
                removeTarget(self, action: #selector(touchUp(button:)), for: .touchDragExit)
            }
        }
    }
    
    public final lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public var touchUpInsideActions: [() -> Void] = []
    public var touchDownActions: [() -> Void] = []
    
    /**
     Easy way to set title for SFButton
     */
    open var title: String? {
        get {
            return title(for: .normal)
        } set {
            return setTitle(newValue, for: .normal)
        }
    }
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame)
        addSubview(rightImageView)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        rightImageView.clipEdges(exclude: [.left], margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), useSafeArea: false)
        rightImageView.width(SFDimension(value: 14))
        super.updateConstraints()
    }
    
    open func updateColors() {
        
        backgroundColor = isTextPicker ? colorStyle.getTextEntryColor() : useClearBackground ? .clear : useAlternativeColors ? colorStyle.getMainColor() : colorStyle.getAlternativeColor()
        
        titleLabel?.backgroundColor = backgroundColor
        
        if setTextColor {
            if useAlternativeTextColor {
                tintColor = colorStyle.getTextColor()
                setTitleColor(colorStyle.getTextColor(), for: .normal)
            } else {
                tintColor = colorStyle.getInteractiveColor()
                setTitleColor(colorStyle.getInteractiveColor(), for: .normal)
            }
        }
        updateSubviewsColors()
    }
    
    @objc public final func animateTouchDown(button: UIButton) {
        titleLabel?.alpha = 0.7
        let animation = SFScaleAnimation(with: button, type: .outside)
        animation.finalScaleX = 0.95
        animation.finalScaleY = 0.95
        animation.finalAlpha = 1.0
        animation.duration = 0.5
        animation.damping = 0.6
        animation.start()
    }
    
    @objc public final func touchUp(button: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.titleLabel?.alpha = 1.0
            button.transform = .identity
        }
    }
    
    public final func addTouchAction(for event: UIControlEvents = .touchUpInside, _ action: @escaping () -> Void) {
        switch event {
        case .touchUpInside: touchUpInsideActions.append(action)
        case .touchDown: touchDownActions.append(action)
        default: return
        }
    }
    
    @objc public final func touchUpInside() {
        touchUpInsideActions.forEach { $0() }
    }
    
    @objc public final func touchDown() {
        touchDownActions.forEach { $0() }
    }
}















