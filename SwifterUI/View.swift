//
//  View.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

class View: SFView {
    
    lazy var textSection: SFTextSection = {
        let textSection = SFTextSection()
        textSection.titleLabel.text = "Prueba"
        textSection.textField.placeholder = "Hola"
        textSection.translatesAutoresizingMaskIntoConstraints = false
        return textSection
    }()
    
    override init(automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        addSubview(textSection)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textSection.clipEdges(margin: ConstraintMargin(top: 12, right: 12, bottom: 0, left: 12), exclude: [.bottom], useSafeArea: true)
        super.layoutSubviews()
    }
    
}






















