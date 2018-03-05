//
//  SFCellView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFTableCell {
    
    // MARK: Static Methods
    
    func height() -> CGFloat
    func identifier() -> String
    
}

open class SFTableViewCell: UITableViewCell, SFViewColorStyle, SFTableCell {
    
    // MARK: - Static Methods
    
    open func height() -> CGFloat {
        return 46
    }
    
    open func identifier() -> String {
        return "SFTableViewCell"
    }
    
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    open lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateColors()
        contentView.addSubview(rightImageView)
        textLabel?.font = UIFont.systemFont(ofSize: 17)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        rightImageView.center(axis: [.y])
        rightImageView.width(SFDimension(value: 16))
        rightImageView.height(SFDimension(value: 16))
        rightImageView.clipRight(to: .right, margin: 8)
    }
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColor() : colorStyle.getMainColor()
        rightImageView.tintColor = colorStyle.getTextColor()
        textLabel?.textColor = colorStyle.getTextColor()
        detailTextLabel?.textColor = useAlternativeColors ? colorStyle.getInteractiveColor() : colorStyle.getPlaceholderColor()
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = useAlternativeColors ? colorStyle.getMainColor() : colorStyle.getAlternativeColor()
        self.selectedBackgroundView = selectedBackgroundView
        updateSubviewsColors()
    }
    
    public func updateSubviewsColors() {
        for view in self.contentView.subviews {
            if let subview = view as? SFViewColorStyle {
                if subview.automaticallyAdjustsColorStyle == true {
                    subview.updateColors()
                }
            }
        }
    }
    
}
















