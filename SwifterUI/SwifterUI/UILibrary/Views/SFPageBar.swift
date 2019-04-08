//
//  SFPageBar.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFPageBarDelegate: class {
    func didSelect(index: Int)
}

open class SFPageBar: SFScrollView {
    
    public class SFPageBarButton: SFButton {
        
        // MARK: - Initializers
        
        public init(automaticallyAdjustsColorStyle: Bool = true, tag: Int, font: UIFont) {
            super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: false, frame: .zero)
            addTouchAnimations = true
            useClearBackground = true
            titleLabel?.font = font
            self.tag = tag
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: - Instance Properties
    
    open var font: UIFont = UIFont.boldSystemFont {
        didSet {
            buttons.forEach({ $0.titleLabel?.font = font })
        }
    }
    open var selectedIndex = 0
    public final lazy var buttons: [SFButton] = []
    open weak var barDelegate: SFPageBarDelegate?
    open var buttonsTintColor: UIColor?
    open var useAlternativeButtonsColor: Bool = false
    open var useAdaptingWidth: Bool = true {
        didSet {
            buttonStackView.distribution = useAdaptingWidth ? .fill : .fillEqually
        }
    }
    open var showIndicator: Bool = true {
        didSet {
            scrollIndicator.isHidden = !showIndicator
        }
    }
    
    public final lazy var buttonStackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: buttons)
        stackView.alignment = .fill
        stackView.distribution = useAdaptingWidth ? .fill : .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    public final lazy var scrollIndicator: UIView = {
        let view = UIView()
        view.isHidden = !showIndicator
        return view
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, items: Int) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        showsHorizontalScrollIndicator = false
        clipsToBounds = false
        addButtons(amount: items)
        select(index: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        contentView.addSubview(buttonStackView)
        contentView.addSubview(scrollIndicator)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        buttonStackView.clipSides(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        scrollIndicator.setHeight(SFDimension(value: 2))
        scrollIndicator.clipBottom(to: .bottom, of: contentView)
        contentView.clipBottom(to: .bottom, of: buttonStackView)
        if !useAdaptingWidth {
            contentView.setWidth(SFDimension(type: .fraction, value: 1))
        }
        super.setConstraints()
    }
    
    public final func addButton() {
        let button = SFPageBarButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, tag: buttons.count, font: font)
        button.addTouchAction { [unowned self] in
            self.didTouch(sfbutton: button)
        }
        buttonStackView.addArrangedSubview(button)
        buttons.append(button)
    }
    
    public final func addButtons(amount: Int) {
        for _ in 0...amount - 1 { addButton() }
    }
    
    open func didTouch(sfbutton: UIButton) {
        barDelegate?.didSelect(index: sfbutton.tag)
        select(index: sfbutton.tag)
    }
    
    open func select(index: Int) {
        
        selectedIndex = index
        
        buttons.enumerated().forEach { (index, button) in
            button.titleLabel?.alpha = self.selectedIndex == index ? 1 : 0.5
            if self.selectedIndex == index && useAdaptingWidth {
                UIView.animate(withDuration: 0.3, animations: {
                    self.scrollIndicator.frame.size.width = self.buttons[self.selectedIndex].frame.size.width
                    self.scrollIndicator.frame.origin.x = self.buttons[self.selectedIndex].frame.origin.x + 16
                })
                
                scrollRectToVisible(CGRect(origin: button.frame.origin, size: CGSize(width: button.frame.size.width + 32, height: button.frame.size.height)), animated: true)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                button.useAlternativeTextColor = self.selectedIndex == index ? false : true
                self.updateColors()
            })
        }
        
        self.scrollIndicator.removeConstraint(type: .width)
        self.scrollIndicator.removeConstraint(type: .left)
        self.scrollIndicator.setWidth(SFDimension(type: .fraction, value: 1), comparedTo: self.buttons[self.selectedIndex])
        self.scrollIndicator.clipLeft(to: .left, of: self.buttons[self.selectedIndex])
    }
    
    open override func updateColors() {
        
        super.updateColors()
        
        if let buttonsTintColor = buttonsTintColor {
            scrollIndicator.backgroundColor = buttonsTintColor
        } else if useAlternativeButtonsColor {
            scrollIndicator.backgroundColor = colorStyle.textColor
        } else {
            scrollIndicator.backgroundColor = colorStyle.interactiveColor
        }
        
        buttons.forEach({
            if useAlternativeButtonsColor {
                $0.setTitleColor(colorStyle.textColor, for: .normal)
            } else if let buttonsTintColor = buttonsTintColor {
                $0.setTextColor = false
                $0.setTitleColor(buttonsTintColor, for: .normal)
            }
        })
    }
}
