//
//  SFColorStyle.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 12/05/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

/**
  The SFColorStyle is an enum representation of a theme where you can get multiple colors depending on the value.
 */
public enum SFColorStyle: Int {

    case light
    case dark

    // MARK: - Instance Methods

    // MARK: - Styles

    /**
     - returns: Corresponding color of an UINavigationBar depending on the current color style.
     */
    public func getBarStyle() -> UIBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .black
        }
    }

    /**
     - returns: Corresponding color of an UIActivityIndicatorView depending on the current color style.
     */
    public func getActivityIndicatorStyle() -> UIActivityIndicatorViewStyle {
        switch self {
        case .light: return .gray
        case .dark: return .white
        }
    }

    /**
     - returns: Corresponding color of an UIActivityIndicatorView depending on the current color style.
     */
    public func getStatusBarStyle() -> UIStatusBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .lightContent
        }
    }

    /**
     - returns: Corresponding color of an UISearchBar depending on the current color style.
     */
    public func getSearchBarStyle() -> UIBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .blackTranslucent
        }
    }

    /**
     - returns: Corresponding color of a keyboard depending on the current color style.
     */
    public func getKeyboardStyle() -> UIKeyboardAppearance {
        switch self {
        case .light: return .default
        case .dark: return .dark
        }
    }

    /**
     - returns: Corresponding color of an UIScrollView's indicator depending on the current color style.
     */
    public func getScrollIndicatorStyle() -> UIScrollViewIndicatorStyle {
        switch self {
        case .light: return .black
        case .dark: return .white
        }
    }

    /**
     - returns: Corresponding blur effect of an UIVisualEffectView depending on the current color style.
     */
    public func getEffectStyle() -> UIBlurEffect {
        switch self {
        case .light: return UIBlurEffect(style: .dark)
        case .dark: return UIBlurEffect(style: .light)
        }
    }

    // MARK: - Colors

    /**
     - returns: Main color used on background.
     */
    public func getMainColor() -> UIColor {
        switch self {
        case .light: return SFColors.white
        case .dark: return SFColors.black
        }
    }

    /**
     - returns: Best color to be used on text for good contrast
     */
    public func getTextColor() -> UIColor {
        switch self {
        case .light: return SFColors.black
        case .dark: return SFColors.white
        }
    }

    /**
     - returns: Alternative background color.
     */
    public func getAlternativeColor() -> UIColor {
        switch self {
        case .light: return SFColors.alternativeWhite
        case .dark: return SFColors.alternativeBlack
        }
    }

    /**
     - returns: Color that contrast with the main background color for text entries like SFTextField
     */
    public func getTextEntryColor() -> UIColor {
        switch self {
        case .light: return SFColors.contrastWhite
        case .dark: return SFColors.contrastBlack
        }
    }

    /**
     - returns: Color for a placeholder that contrast with getTextEntryColor()
     */
    public func getPlaceholderColor() -> UIColor {
        switch self {
        case .light: return SFColors.darkGray
        case .dark: return SFColors.lightGray
        }
    }

    /**
     - returns: Color for separators in SFTableView
     */
    public func getSeparatorColor() -> UIColor {
        switch self {
        case .light: return SFColors.separatorWhite
        case .dark: return SFColors.separatorBlack
        }
    }

    /**
     - returns: Color for interactive items like buttons.
     */
    public func getInteractiveColor() -> UIColor {
        switch self {
        case .light: return SFColors.blue
        case .dark: return SFColors.orange
        }
    }

}
