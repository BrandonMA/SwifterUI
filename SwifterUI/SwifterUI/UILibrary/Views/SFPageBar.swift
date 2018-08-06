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
    
    // MARK: - Instance Properties
    
    open var font: UIFont = UIFont.boldSystemFont(ofSize: 17) {
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = useAdaptingWidth ? .fill : .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    public final lazy var scrollIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = !showIndicator
        return view
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, items: Int) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        contentView.addSubview(buttonStackView)
        contentView.addSubview(scrollIndicator)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
        showsHorizontalScrollIndicator = false
        clipsToBounds = false
        addButtons(amount: items)
        select(index: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    public final func addButton() {
        let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        button.addTouchAction { [unowned self] in
            self.didTouch(sfbutton: button)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = font
        button.addTouchAnimations = true
        button.useClearBackground = true
        button.tag = buttons.count
        buttonStackView.addArrangedSubview(button)
        buttons.append(button)
    }
    
    public final func addButtons(amount: Int) {
        for _ in 0...amount - 1 { addButton() }
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        
        if mainContraints.isEmpty {
            mainContraints.append(contentsOf: buttonStackView.clipEdges(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)))
            
            if !useAdaptingWidth {
                mainContraints.append(contentView.width(SFDimension(type: .fraction, value: 1)))
            }
            
            mainContraints.append(scrollIndicator.height(SFDimension(value: 2)))
            mainContraints.append(scrollIndicator.clipBottom(to: .bottom, of: contentView))
            
            mainContraints.append(contentView.clipBottom(to: .bottom, of: buttonStackView))
        }
        
        
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
        self.scrollIndicator.remove(constraintType: .width)
        self.scrollIndicator.remove(constraintType: .left)
        self.scrollIndicator.width(SFDimension(type: .fraction, value: 1), comparedTo: self.buttons[self.selectedIndex])
        self.scrollIndicator.clipLeft(to: .left, of: self.buttons[self.selectedIndex])
    }
    
    open override func updateColors() {
        
        super.updateColors()
        
        if let buttonsTintColor = buttonsTintColor {
            scrollIndicator.backgroundColor = buttonsTintColor
        } else if useAlternativeButtonsColor {
            scrollIndicator.backgroundColor = colorStyle.getTextColor()
        } else {
            scrollIndicator.backgroundColor = colorStyle.getInteractiveColor()
        }
        
        buttons.forEach({
            if useAlternativeButtonsColor {
                $0.setTitleColor(colorStyle.getTextColor(), for: .normal)
            } else if let buttonsTintColor = buttonsTintColor {
                $0.setTextColor = false
                $0.setTitleColor(buttonsTintColor, for: .normal)
            }
        })
    }
}













