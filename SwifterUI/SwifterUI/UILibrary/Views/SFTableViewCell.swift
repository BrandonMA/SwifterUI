//
//  SFCellView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewCell: UITableViewCell, SFViewColorStyle, SFLayoutView {
    
    // MARK: - Class Properties
    
    open class var height: CGFloat {
        return 46
    }
    
    open class var identifier: String {
        return "SFTableViewCell"
    }
    
    // MARK: - Instance Properties
    
    open var customConstraints: Constraints = []
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    open lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareSubviews()
        setConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func prepareSubviews() {
        contentView.addSubview(rightImageView)
        textLabel?.font = UIFont.systemFont
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    open func setConstraints() {
        rightImageView.clipCenterY(to: .centerY)
        rightImageView.setWidth(SFDimension(value: 16))
        rightImageView.setHeight(SFDimension(value: 16))
        rightImageView.clipRight(to: .right, margin: 8)
    }
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        rightImageView.tintColor = colorStyle.textColor
        textLabel?.textColor = colorStyle.textColor
        detailTextLabel?.textColor = useAlternativeColors ? colorStyle.interactiveColor : colorStyle.placeholderColor
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = useAlternativeColors ? colorStyle.mainColor : colorStyle.contrastColor
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
