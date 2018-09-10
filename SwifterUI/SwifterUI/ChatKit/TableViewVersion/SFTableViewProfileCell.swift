//
//  SFTableViewProfileCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewContactCell: SFTableViewCell {
    
    // MARK: - Class Properties
    
    open override class var height: CGFloat {
        return 52
    }
    
    open override class var identifier: String {
        return "SFTableViewContactCell"
    }
    
    // MARK: - Instance Properties
    
    open lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 18
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    open lazy var nameLabel: SFLabel = {
        let label = SFLabel(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: [profileImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func prepareSubviews() {
        contentView.addSubview(stackView)
        super.prepareSubviews()
    }
    
    open override func setConstraints() {
        stackView.clipSides(margin: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        profileImageView.width(SFDimension(value: 36))
        super.setConstraints()
    }
    
}
