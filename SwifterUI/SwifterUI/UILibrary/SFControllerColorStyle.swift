//
//  SFControllerProtocol.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 28/08/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFControllerColorStyle: SFColorStyleProtocol {

    // MARK: - Instance Properties

    /**
     This enables preferredStatusBarStyle changes on the go, without needing to override on each view controller
     */
    var statusBarStyle: UIStatusBarStyle { get set }

    /**
     Enable navigation bar color handling
     */
    var automaticallyTintNavigationBar: Bool { get set }

    // MARK: - Instance Methods

    /**
     Call updateColors and start a listener for brightness changes
     */
    func checkColorStyle()

    /**
     Start a listener for brightness changes
     */
    func checkColorStyleListener()

}

public extension SFControllerColorStyle where Self: UIViewController {

    // MARK: - Instance Methods

    func checkColorStyle() {
        if automaticallyAdjustsColorStyle == true {
            updateColors()
            checkColorStyleListener()
        }
    }

    func updateSubviewsColors() {
        if let view = self.view as? SFViewColorStyle {
            if view.automaticallyAdjustsColorStyle == true {
                view.updateColors()
            }
        }
    }

    func updateNavItem() {
        navigationItem.searchController?.searchBar.barStyle = self.colorStyle.barStyle
        navigationItem.searchController?.searchBar.tintColor = self.colorStyle.interactiveColor
        navigationItem.searchController?.searchBar.keyboardAppearance = self.colorStyle.keyboardStyle
    }

}
