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
    
    open var useClearColor: Bool = false
    
    open var isTextPicker: Bool = false
    
    public final var addTouchAnimations: Bool = false {
        didSet {
            if addTouchAnimations == true {
                addTarget(self, action: #selector(touchDown(button:)), for: .touchDown)
                addTarget(self, action: #selector(touchUp(button:)), for: .touchUpInside)
                addTarget(self, action: #selector(touchUp(button:)), for: .touchDragExit)
            } else {
                removeTarget(self, action: #selector(touchDown(button:)), for: .touchDown)
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
    
    open var actions: [() -> Void] = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame)
        addSubview(rightImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func updateConstraints() {
        rightImageView.clipEdges(margin: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), exclude: [.left], useSafeArea: false)
        rightImageView.width(SFDimension(value: 14))
        super.updateConstraints()
    }
    
    open func updateColors() {
        backgroundColor = isTextPicker ? colorStyle.getTextEntryColor() : useClearColor ? .clear : useAlternativeColors ? colorStyle.getMainColor() : colorStyle.getAlternativeColor()
        if setTextColor {
            if useAlternativeTextColor {
                tintColor = colorStyle.getPlaceholderColor()
                setTitleColor(colorStyle.getPlaceholderColor(), for: .normal)
            } else {
                tintColor = colorStyle.getInteractiveColor()
                setTitleColor(colorStyle.getInteractiveColor(), for: .normal)
            }
        }
        updateSubviewsColors()
    }
    
    @objc public final func touchDown(button: UIButton) {
        titleLabel?.alpha = 0.7
        let animation = SFScaleAnimation(with: button, type: .outside)
        animation.finalScaleX = 0.9
        animation.finalScaleY = 0.9
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
    
    public final func add(action: @escaping () -> Void) {
        actions.append(action)
    }
}

