//
//  SFImageZoomView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 29/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFImageZoomView: UIScrollView {
    
    // MARK: - Instance Properties

    public final lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubview(imageView)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
