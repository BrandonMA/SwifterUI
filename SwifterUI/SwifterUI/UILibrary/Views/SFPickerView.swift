//
//  SFModalView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPickerView: SFView {
    
    // MARK: - Instance Properties
    
    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.7
        return view
    }()
    
    open lazy var backgroundView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    open lazy var closeButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.setImage(SFAssets.imageOfClose.withRenderingMode(.alwaysTemplate), for: .normal)
        button.useAlternativeTextColor = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        return button
    }()
    
    open lazy var doneButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.useAlternativeTextColor = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.setTitle("Listo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return button
    }()
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = .boldSystemFont(ofSize: 21)
        label.text = "Titulo"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    open var middleView: UIView
    
    private var buttons: [UIButton]
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero, middleView: UIView? = nil, buttons: [UIButton] = []) {
        
        self.middleView = middleView ?? SFView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        
        isOpaque = false
        
        addSubview(blurView)
        addSubview(backgroundView)
        
        backgroundView.addSubview(closeButton)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(self.middleView)
        
        if buttons.count > 0 {
            self.middleView.translatesAutoresizingMaskIntoConstraints = false
            buttons.forEach({ (button) in
                button.translatesAutoresizingMaskIntoConstraints = false
                button.layer.cornerRadius = 10
                self.middleView.addSubview(button)
            })
        } else {
            backgroundView.addSubview(doneButton)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        blurView.clipEdges(useSafeArea: false)
        
        middleView.clipRight(to: .right, margin: 8)
        middleView.clipLeft(to: .left, margin: 8)
        
        if buttons.count > 0 {
            middleView.clipBottom(to: .bottom, margin: 8)
            for (index, button) in buttons.enumerated() {
                button.clipRight(to: .right)
                button.clipLeft(to: .left)
                button.height(SFDimension(value: 48))
                if index == 0 {
                    button.clipBottom(to: .bottom)
                } else {
                    button.clipBottom(to: .top, of: buttons[index - 1], margin: 8)
                }
                if index == buttons.count - 1 {
                    middleView.clipTop(to: .top, of: button)
                }
            }
        } else {
            doneButton.clipEdges(margin: ConstraintMargin(top: 0, right: 8, bottom: 8, left: 8), exclude: [.top])
            doneButton.height(SFDimension(value: 48))
            middleView.clipBottom(to: .top, of: doneButton)
            middleView.height(SFDimension(value: 200))
        }
        
        closeButton.width(SFDimension(value: 32))
        closeButton.height(SFDimension(value: 32))
        closeButton.clipBottom(to: .top, of: middleView, margin: 8)
        closeButton.clipRight(to: .right, margin: 8)
        
        titleLabel.center(axis: [.x])
        titleLabel.center(axis: [.y], in: closeButton)
        
        backgroundView.clipEdges(margin: ConstraintMargin(top: 0, right: 12, bottom: 12, left: 12), exclude: [.top])
        backgroundView.clipTop(to: .top, of: closeButton, margin: -8)
        
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        blurView.effect = colorStyle.getEffectStyle()
        if let pickerView = middleView as? UIPickerView {
            if pickerView.subviews.count >= 2 {
                pickerView.subviews[1].backgroundColor = colorStyle.getSeparatorColor()
                pickerView.subviews[2].backgroundColor = colorStyle.getSeparatorColor()
            }
        }
        updateSubviewsColors()
    }
}





















