//
//  SFTableViewProfileCell.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 10/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFTableViewProfileCell: SFTableViewCell {

    // MARK: - Class Properties

    open override class var height: CGFloat {
        return 52
    }

    open override class var identifier: String {
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
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
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
        profileImageView.center(axis: [.vertical])

        nameLabel.center(axis: [.vertical])
        nameLabel.clipLeft(to: .right, of: profileImageView, margin: 12)
    }

}
