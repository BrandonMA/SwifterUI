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
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 3)
        return label
    }()
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = textColor
        return imageView
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
            imageView.tintColor = textColor
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
        addTargets()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func addTargets() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter, .touchDragInside])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel, .touchDragOutside, .touchUpOutside])
        addTarget(self, action: #selector(performActions), for: .touchUpInside)
    }
    
    open func prepareSubviews() {
        addSubview(titleLabel)
        addSubview(imageView)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        titleLabel.clipSides()
        imageView.clipSides()
    }
    
    open func updateColors() {
        if useHighlightTextColor {
            titleLabel.textColor = highlightedTextColor ?? colorStyle.interactiveColor
        } else if let textColor = textColor {
            titleLabel.textColor = textColor
        } else {
            titleLabel.textColor = useAlternativeColors ? colorStyle.interactiveColor : colorStyle.textColor
        }
        imageView.tintColor = titleLabel.textColor
        
        backgroundColor = useAlternativeColors ? .clear : colorStyle.alternativeColor
        normalColor = backgroundColor
    }
    
    @objc open func touchDown() {
        
        animator.stopAnimation(true)
        
        if let color = highlightedTextColor {
            titleLabel.textColor = color
            imageView.tintColor = titleLabel.textColor
        }
        
        if let color = highlightedColor {
            backgroundColor = color
        }
        
        if automaticallyAdjustsColorStyle {
            
            if useAlternativeColors {
                self.alpha = 0.5
            }
            
            backgroundColor = highlightedColor ?? (useAlternativeColors ? .clear : colorStyle.contrastColor)
        }
    }
    
    @objc open func touchUp() {
        
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            
            if self.useAlternativeColors {
                self.alpha = 1.0
            }
            self.backgroundColor = self.normalColor
            
            if let textColor = self.textColor {
                self.titleLabel.textColor = textColor
                self.imageView.tintColor = textColor
            }
        })
        animator.startAnimation()
    }
    
    @objc open func performActions() {
        touchActions.forEach({ $0() })
    }
    
    open func addAction(_ action: @escaping () -> Void) {
        touchActions.append(action)
    }
    
    open func insertAction(_ action: @escaping () -> Void, at index: Int) {
        touchActions.insert(action, at: index)
    }
}
