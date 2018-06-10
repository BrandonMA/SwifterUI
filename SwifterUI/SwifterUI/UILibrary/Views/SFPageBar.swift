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
    
    open lazy var buttonStackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        contentView.addSubview(buttonStackView)
        showsHorizontalScrollIndicator = false
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
            button.useClearColor = true
            button.titleLabel?.alpha = selectedIndex == index ? 1 : 0.7
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            buttonStackView.addArrangedSubview(button)
            return button
        })
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        buttonStackView.clipEdges(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
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
            UIView.animate(withDuration: 0.4, animations: {
                button.titleLabel?.alpha = self.selectedIndex == index ? 1 : 0.7
            })
        }
    }
}
