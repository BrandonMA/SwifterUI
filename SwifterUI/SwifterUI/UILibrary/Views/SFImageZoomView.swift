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
    
    open var automaticallyAdjustsColorStyle: Bool = false
    
    open var useAlternativeColors: Bool = false
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        self.automaticallyAdjustsColorStyle = automaticallyAdjustsColorStyle
        super.init(frame: frame)
        updateColors()
        addSubview(imageView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func updateColors() {
        backgroundColor = useAlternativeColors ? colorStyle.getAlternativeColor() : colorStyle.getMainColor()
        updateSubviewsColors()
    }
    

}
