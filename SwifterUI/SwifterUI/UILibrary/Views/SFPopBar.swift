//
//  SFPopBar.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPopBar: SFView {
    
    // MARK: - Instance Properties
    
    open override var tintColor: UIColor! {
        didSet {
            dismissButton.tintColor = tintColor
            titleLabel.textColor = tintColor
        }
    }
    
    lazy var dismissButton: SFButton = {
        let button = SFButton(automaticallyAdjustsColorStyle: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.useAlternativeColors = true
        button.setImage(SFAssets.imageOfArrowDown.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: false)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        addSubview(dismissButton)
        addSubview(titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        dismissButton.center(axis: [.y])
        dismissButton.clipLeft(to: .left, margin: 12)
        dismissButton.width(SFDimension(value: 28))
        dismissButton.height(SFDimension(value: 28))
        titleLabel.center()
        height(SFDimension(value: 44))
    }
    
    open override func updateColors() {
        super.updateColors()
        self.tintColor = colorStyle.getInteractiveColor()
        addShadow(color: colorStyle.getSeparatorColor(), offSet: CGSize(width: 0, height: 1), radius: 0, opacity: 1)
    }
    
}
