//
//  SFCellView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewCell: UITableViewCell, SFViewColorStyle {
        
    // MARK: - Instance Properties
    
    open var automaticallyAdjustsColorStyle: Bool = true
    
    open var useAlternativeColors: Bool = false
    
    lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(rightImageView)
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
        backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColors() : colorStyle.getMainColor()
        rightImageView.tintColor = colorStyle.getTextColor()
        textLabel?.textColor = colorStyle.getTextColor()
        detailTextLabel?.textColor = useAlternativeColors ? colorStyle.getInteractiveColor() : colorStyle.getPlaceholderColor()
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = useAlternativeColors ? colorStyle.getMainColor() : colorStyle.getAlternativeColors()
        self.selectedBackgroundView = selectedBackgroundView
        updateSubviewsColors()
    }
    
}
















