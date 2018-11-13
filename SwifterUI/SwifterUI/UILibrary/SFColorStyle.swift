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
public enum SFColorStyle {
    
    case light
    case dark
    
    // MARK: - Instance Methods
    
    // MARK: - Styles
    
    /**
     - returns: Corresponding color of an UINavigationBar depending on the current color style.
     */
    public var barStyle: UIBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .black
        }
    }
    
    /**
     - returns: Corresponding color of an UIActivityIndicatorView depending on the current color style.
     */
    public var activityIndicatorStyle: UIActivityIndicatorView.Style {
        switch self {
        case .light: return .gray
        case .dark: return .white
        }
    }
    
    /**
     - returns: Corresponding color of an UIActivityIndicatorView depending on the current color style.
     */
    public var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .lightContent
        }
    }
    
    /**
     - returns: Corresponding color of a keyboard depending on the current color style.
     */
    public var keyboardStyle: UIKeyboardAppearance {
        switch self {
        case .light: return .default
        case .dark: return .dark
        }
    }
    
    /**
     - returns: Corresponding color of an UIScrollView's indicator depending on the current color style.
     */
    public var scrollIndicatorStyle: UIScrollView.IndicatorStyle {
        switch self {
        case .light: return .black
        case .dark: return .white
        }
    }
    
    /**
     - returns: Corresponding blur effect of an UIVisualEffectView depending on the current color style.
     */
    public var blurEffectStyle: UIBlurEffect {
        switch self {
        case .light: return UIBlurEffect(style: .dark)
        case .dark: return UIBlurEffect(style: .light)
        }
    }
    
    // MARK: - Colors
    
    /**
     - returns: Main color used on background.
     */
    public var mainColor: UIColor {
        switch self {
        case .light: return SFColors.white
        case .dark: return SFColors.black
        }
    }
    
    /**
     - returns: Best color to be used on text for good contrast
     */
    public var textColor: UIColor {
        switch self {
        case .light: return SFColors.black
        case .dark: return SFColors.white
        }
    }
    
    /**
     - returns: Alternative background color.
     */
    public var alternativeColor: UIColor {
        switch self {
        case .light: return SFColors.alternativeWhite
        case .dark: return SFColors.alternativeBlack
        }
    }
    
    /**
     - returns: Color that contrast with the main background color for text entries like SFTextField
     */
    public var contrastColor: UIColor {
        switch self {
        case .light: return SFColors.contrastWhite
        case .dark: return SFColors.contrastBlack
        }
    }
    
    /**
     - returns: Color for a placeholder that contrast with getTextEntryColor()
     */
    public var placeholderColor: UIColor {
        switch self {
        case .light: return SFColors.darkGray
        case .dark: return SFColors.lightGray
        }
    }
    
    /**
     - returns: Color for separators in SFTableView
     */
    public var separatorColor: UIColor {
        switch self {
        case .light: return SFColors.separatorWhite
        case .dark: return SFColors.separatorBlack
        }
    }
    
    /**
     - returns: Color for interactive items like buttons.
     */
    public var interactiveColor: UIColor {
        switch self {
        case .light: return SFColors.blue
        case .dark: return SFColors.orange
        }
    }
    
}
