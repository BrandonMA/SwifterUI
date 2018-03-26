//
//  SFColorStyleProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 12/06/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

// minimumBrighness: Global variable to indicate minimum level of brightness for dark mode
public var minimumBrighness: CGFloat = 0.30

public protocol SFColorStyleProtocol {

    // MARK: - Instance Properties

    // automaticallyAdjustsColorStyle: This property enables automatic change between light and dark mode
    var automaticallyAdjustsColorStyle: Bool { get set }

    var colorStyle: SFColorStyle { get }

    // MARK: - Instance Methods

    func updateColors()

    func updateSubviewsColors()
}

public extension SFColorStyleProtocol {

    // MARK: - Instance Properties

    public var colorStyle: SFColorStyle {
        return UIScreen.main.brightness > minimumBrighness ? .light : .dark
    }

}
