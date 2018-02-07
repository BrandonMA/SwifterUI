//
//  View.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class View: SFView, UITextViewDelegate {
    
    lazy var redView: SFView = {
        let view = SFView(automaticallyAdjustsColorStyle: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textView: SFTextView = {
        var field = SFTextView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.isScrollEnabled = false
        return field
    }()
    
    required init(automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        addSubview(redView)
        addSubview(textView)
        shouldHaveAlternativeColors = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        if traitCollection.horizontalSizeClass == .regular {
            redView.removeAllConstraints()
            redView.height(SFDimension(type: .fraction, value: 1/2))
            redView.width(SFDimension(type: .fraction, value: 1/2))
            redView.center()
            textView.removeAllConstraints()
            textView.clipRight(to: .right)
            textView.clipBottom(to: .top, of: redView)
            textView.clipLeft(to: .left)
            textView.height(SFDimension(value: 64))
        } else if traitCollection.horizontalSizeClass == .compact {
            redView.removeAllConstraints()
            redView.height(SFDimension(type: .fraction, value: 1/2))
            redView.width(SFDimension(type: .fraction, value: 1))
            redView.center()
            textView.removeAllConstraints()
            textView.clipTop(to: .top)
            textView.clipRight(to: .right)
            textView.clipBottom(to: .top, of: redView)
            textView.clipLeft(to: .left)
        }
        
        super.layoutSubviews()
        
        redView.set(gradient: SFGradient(with: [UIColor(hex: "cb2d3e").cgColor, UIColor(hex: "ef473a").cgColor], direction: .horizontal))
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.updateHeightConstraint()
    }
}






















