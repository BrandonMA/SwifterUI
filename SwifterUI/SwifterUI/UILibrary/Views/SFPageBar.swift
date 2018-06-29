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
    
    open var titles: [String] = []
    open var selectedIndex = 0
    open lazy var buttons: [SFButton] = []
    open weak var barDelegate: SFPageBarDelegate?
    open var buttonsTintColor: UIColor?
    open var useAlternativeButtonsColor: Bool = false
    open var useAdaptingWidth: Bool = true {
        didSet {
            buttonStackView.distribution = useAdaptingWidth ? .fill : .fillEqually
        }
    }
    open var useNavigationLikeBackground: Bool = false
    
    open lazy var buttonStackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = useAdaptingWidth ? .fill : .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        contentView.addSubview(buttonStackView)
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
        showsHorizontalScrollIndicator = false
        clipsToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func configure(with titles: [String]) {
        self.titles = titles
        self.buttons = titles.enumerated().map({ (index, title) -> SFButton in
            let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
            button.addTarget(self, action: #selector(didTouch(sfbutton:)), for: .touchUpInside)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.useAlternativeTextColor = selectedIndex == index ? false : true
            button.titleLabel?.alpha = selectedIndex == index ? 1 : 0.5
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            button.addTouchAnimations = true
            button.useAlternativeColors = useAlternativeColors
            buttonStackView.addArrangedSubview(button)
            return button
        })
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        buttonStackView.clipEdges(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        if !useAdaptingWidth {
            contentView.width(SFDimension(type: .fraction, value: 1))
        }
        contentView.clipBottom(to: .bottom, of: buttonStackView)
    }
    
    @objc open func didTouch(sfbutton: UIButton) {
        buttons.enumerated().forEach { (index, button) in
            if sfbutton == button {
                selectedIndex = index
            }
        }
        barDelegate?.didSelect(index: selectedIndex)
        select(index: selectedIndex)
    }
    
    open func select(index: Int) {
        selectedIndex = index
        buttons.enumerated().forEach { (index, button) in
            if self.selectedIndex == index && useAdaptingWidth {
                setContentOffset(CGPoint(x: button.frame.origin.x, y: 0), animated: true)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                button.titleLabel?.alpha = self.selectedIndex == index ? 1 : 0.5
                button.useAlternativeTextColor = self.selectedIndex == index ? false : true
                self.updateColors()
            })
        }
    }
    
    open override func updateColors() {
        
        super.updateColors()
        
        buttons.forEach({
            if useAlternativeButtonsColor {
                $0.setTitleColor(colorStyle.getTextColor(), for: .normal)
            }
            
            if let buttonsTintColor = buttonsTintColor {
                $0.setTextColor = false
                $0.setTitleColor(buttonsTintColor, for: .normal)
            }
        })
        
        if useNavigationLikeBackground {
            contentView.backgroundColor = colorStyle == .light ? UIColor(hex: "F9F9F9").withAlphaComponent(1) : UIColor(hex: "141414").withAlphaComponent(1)
            if colorStyle == .light {
                addShadow(color: .black, offSet: CGSize(width: 0, height: 0.5), radius: 0, opacity: 0.2)
            } else {
                addShadow(color: .white, offSet: CGSize(width: 0, height: 1), radius: 0, opacity: 0.16)
            }
        }
    }
}













