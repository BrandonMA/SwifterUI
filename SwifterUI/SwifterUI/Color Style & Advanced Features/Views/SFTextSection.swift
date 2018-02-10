//
//  SFTextSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTextSection: SFView {
    
    // MARK: - Instance Properties
    
    open override var shouldHaveAlternativeColors: Bool {
        didSet {
            textField.shouldHaveAlternativeColors = self.shouldHaveAlternativeColors
        }
    }
    
    open lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    open lazy var textField: SFTextField = {
        let textField = SFTextField(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.setMargin(left: 12, right: 12)
        return textField
    }()
    
    // MARK: - Initializers
    
    public required init(automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        addSubview(titleLabel)
        addSubview(textField)
        shouldHaveAlternativeColors = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        titleLabel.clipEdges(exclude: [.bottom])
        textField.height(SFDimension(value: 34))
        textField.clipEdges(exclude: [.top, .bottom])
        textField.clipTop(to: .bottom, of: titleLabel, margin: 8)
        super.layoutSubviews()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
    
}
