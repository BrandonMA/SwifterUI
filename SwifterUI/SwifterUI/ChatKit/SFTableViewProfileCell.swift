//
//  SFTableViewProfileCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewProfileCell: SFTableViewCell {
    
    // MARK: - Static Methods
    
    open override func height() -> CGFloat {
        return 56
    }
    
    open override func identifier() -> String {
        return "SFTableViewProfileCell"
    }
    
    // MARK: - Instance Properties
    
    open lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 18
        return imageView
    }()
    
    open lazy var nameLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        profileImageView.height(SFDimension(value: 36))
        profileImageView.width(SFDimension(value: 36))
        profileImageView.clipLeft(to: .left, margin: 12)
        profileImageView.center(axis: [.y])
        
        nameLabel.center(axis: [.y])
        nameLabel.clipLeft(to: .right, of: profileImageView, margin: 12)
        
    }
    
}




















