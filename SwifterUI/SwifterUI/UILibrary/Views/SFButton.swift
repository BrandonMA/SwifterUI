//
//  SFButton.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 06/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFButton: UIButton, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    open var setTextColor: Bool = true
    
    open var useAlternativeTextColor: Bool = false
    
    open var useClearBackground: Bool = false
    
    open var isTextPicker: Bool = false
    
    open var customConstraints: Constraints = []
    
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
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        
        prepareSubviews()
        setConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    public func prepareSubviews() {
        addSubview(rightImageView)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    public func setConstraints() {
        customConstraints.append(contentsOf: rightImageView.clipSides(exclude: [.left], margin: UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8), useSafeArea: false))
        customConstraints.append(rightImageView.setWidth(SFDimension(value: 14)))
    }
    
    open func updateColors() {
        
        backgroundColor = isTextPicker ? colorStyle.contrastColor : useClearBackground ? .clear : useAlternativeColors ? colorStyle.mainColor : colorStyle.alternativeColor
        
        titleLabel?.backgroundColor = backgroundColor
        
        if setTextColor {
            if useAlternativeTextColor {
                tintColor = colorStyle.textColor
                setTitleColor(colorStyle.textColor, for: .normal)
            } else {
                tintColor = colorStyle.interactiveColor
                setTitleColor(colorStyle.interactiveColor, for: .normal)
            }
        }
        updateSubviewsColors()
    }
    
    @objc public final func animateTouchDown(button: UIButton) {
        titleLabel?.alpha = 0.7
    }
    
    @objc public final func touchUp(button: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.titleLabel?.alpha = 1.0
            button.transform = .identity
        }
    }
    
    public final func addTouchAction(for event: UIControl.Event = .touchUpInside, _ action: @escaping () -> Void) {
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
