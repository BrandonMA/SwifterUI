//
//  SFBasicButton.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/08/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFFluidButton: UIControl, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = true
    open var useAlternativeColors: Bool = false
    open var customConstraints: Constraints = []
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: false, useAlternativeColors: self.useAlternativeColors)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    private var animator = UIViewPropertyAnimator()
    
    open var normalColor: UIColor? {
        didSet {
            backgroundColor = normalColor
        }
    }
    open var highlightedColor: UIColor?
    open var highlightedTextColor: UIColor?
    open var useHighlightTextColor: Bool = false
    open var textColor: UIColor? {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    open var title: String? {
        get {
            return titleLabel.text
        } set {
            titleLabel.text = newValue
        }
    }
    
    open var touchActions: [() -> Void] = []
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame)
        prepareSubviews()
        setConstraints()
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter, .touchDragInside])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel, .touchDragOutside, .touchUpOutside])
        addTarget(self, action: #selector(performActions), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func prepareSubviews() {
        addSubview(titleLabel)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        titleLabel.clipEdges()
    }
    
    open func updateColors() {
        if useHighlightTextColor {
            titleLabel.textColor = highlightedTextColor ?? colorStyle.getInteractiveColor()
        } else if let textColor = textColor {
            titleLabel.textColor = textColor
        } else {
            titleLabel.textColor = useAlternativeColors ? colorStyle.getInteractiveColor() : colorStyle.getTextColor()
        }
        backgroundColor = useAlternativeColors ? .clear : colorStyle.getAlternativeColor()
        normalColor = backgroundColor
    }
    
    @objc private func touchDown() {
        
        animator.stopAnimation(true)
        
        if let color = highlightedTextColor {
            titleLabel.textColor = color
        }
        
        if let color = highlightedColor {
            backgroundColor = color
        }
        
        if automaticallyAdjustsColorStyle {
            
            if useAlternativeColors {
                self.alpha = 0.5
            }
            
            backgroundColor = highlightedColor ?? (useAlternativeColors ? .clear : colorStyle.getContrastColor())
        }
    }
    
    @objc private func touchUp() {
        
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            
            if self.useAlternativeColors {
                self.alpha = 1.0
            }
            self.backgroundColor = self.normalColor
            
            if let textColor = self.textColor {
                self.titleLabel.textColor = textColor
            }
        })
        animator.startAnimation()
    }
    
    @objc private func performActions() {
        touchActions.forEach({ $0() })
    }
    
    open func addAction(_ action: @escaping () -> Void) {
        touchActions.append(action)
    }
    
    open func insertAction(_ action: @escaping () -> Void, at index: Int) {
        touchActions.insert(action, at: index)
    }
}














