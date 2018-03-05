//
//  SFColorStyle.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 12/05/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

// This enum defines the different color styles providede by SwifterUI and some convenience methods to get colors
public enum SFColorStyle: Int {
    
    case light
    case dark
    
    // MARK: - Instance Methods
    
    // MARK: - Styles
    
    public func getBarStyle() -> UIBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .black
        }
    }
    
    public func getActivityIndicatorStyle() -> UIActivityIndicatorViewStyle {
        switch self {
        case .light: return .gray
        case .dark: return .white
        }
    }
    
    public func getStatusBarStyle() -> UIStatusBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .lightContent
        }
    }
    
    public func getSearchBarStyle() -> UIBarStyle {
        switch self {
        case .light: return .default
        case .dark: return .blackTranslucent
        }
    }
    
    public func getKeyboardStyle() -> UIKeyboardAppearance {
        switch self {
        case .light: return .default
        case .dark: return .dark
        }
    }
    
    public func getScrollIndicatorStyle() -> UIScrollViewIndicatorStyle {
        switch self {
        case .light: return .black
        case .dark: return .white
        }
    }
    
    public func getEffectStyle() -> UIBlurEffect {
        switch self {
        case .light: return UIBlurEffect(style: .dark)
        case .dark: return UIBlurEffect(style: .light)
        }
    }
    
    // MARK: - Colors
    
    public func getMainColor() -> UIColor {
        switch self {
        case .light: return SFColors.white
        case .dark: return SFColors.black
        }
    }
    
    public func getTextColor() -> UIColor {
        switch self {
        case .light: return SFColors.black
        case .dark: return SFColors.white
        }
    }
    
    public func getAlternativeColor() -> UIColor {
        switch self {
        case .light: return SFColors.alternativeWhite
        case .dark: return SFColors.alternativeBlack
        }
    }
    
    public func getTextEntryColor() -> UIColor {
        switch self {
        case .light: return SFColors.contrastWhite
        case .dark: return SFColors.contrastBlack
        }
    }
    
    public func getPlaceholderColor() -> UIColor {
        switch self {
        case .light: return SFColors.darkGray
        case .dark: return SFColors.lightGray
        }
    }
    
    public func getSeparatorColor() -> UIColor {
        switch self {
        case .light: return SFColors.separatorWhite
        case .dark: return SFColors.separatorBlack
        }
    }
    
    public func getInteractiveColor() -> UIColor {
        switch self {
        case .light: return SFColors.blue
        case .dark: return SFColors.orange
        }
    }
    
}





















