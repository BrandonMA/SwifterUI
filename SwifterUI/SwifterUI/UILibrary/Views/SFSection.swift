//
//  SFSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFSection: SFView {
    
    // MARK: - Instance Properties
    
    public final lazy var titleLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.boldSystemFont
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stackView: SFStackView = {
        let stack = SFStackView(arrangedSubviews: [titleLabel, bottomView])
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
    
    open var bottomView: UIView
    
    open var text: String? {
        get {
            return nil
        } set {
            
        }
    }
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero, bottomView: UIView) {
        self.bottomView = bottomView
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        addSubview(stackView)
        titleLabel.setContentHuggingPriority(.init(251), for: .vertical)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.setContentHuggingPriority(.init(250), for: .vertical)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        stackView.clipSides()
        super.setConstraints()
    }
    
    open override func updateColors() {
        backgroundColor = .clear
        updateSubviewsColors()
    }
}
