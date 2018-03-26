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

    // statusBarStyle: This enables preferredStatusBarStyle changes on the go, without needing to
    var statusBarStyle: UIStatusBarStyle { get set }

    var automaticallyTintNavigationBar: Bool { get set }

    // MARK: - Instance Methods

    func checkColorStyle()

    func checkColorStyleListener()

}

public extension SFControllerColorStyle where Self: UIViewController {

    // MARK: - Instance Methods

    public func checkColorStyle() {
        if automaticallyAdjustsColorStyle == true {
            updateColors()
            checkColorStyleListener()
        }
    }

    public func updateSubviewsColors() {
        if let view = self.view as? SFViewColorStyle {
            if view.automaticallyAdjustsColorStyle == true {
                view.updateColors()
            }
        }
    }

    public func updateNavItem() {
        navigationItem.searchController?.searchBar.barStyle = self.colorStyle.getSearchBarStyle()
        navigationItem.searchController?.searchBar.tintColor = self.colorStyle.getInteractiveColor()
        navigationItem.searchController?.searchBar.keyboardAppearance = self.colorStyle.getKeyboardStyle()
    }

}
