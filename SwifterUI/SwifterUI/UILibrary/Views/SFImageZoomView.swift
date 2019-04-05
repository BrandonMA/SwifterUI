//
//  SFImageZoomView.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 29/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFImageZoomView: UIScrollView, SFViewColorStyle {
    
    // MARK: - Instance Properties

    public final lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var automaticallyAdjustsColorStyle: Bool = false
    
    public var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        self.useAlternativeColors = useAlternativeColors
        super.init(frame: frame)
        addSubview(imageView)
        
        if automaticallyAdjustsColorStyle {
            updateColors()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame.origin = .zero
    }
    
    public func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.alternativeColor : colorStyle.mainColor
        updateSubviewsColors()
    }
}
