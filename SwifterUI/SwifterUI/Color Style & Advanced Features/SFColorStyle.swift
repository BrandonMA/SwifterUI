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
    
    // MARK: - Styles
    
    public func getNavigationBarStyle() -> UIBarStyle {
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
        case .light: return SFAssets.white
        case .dark: return SFAssets.black
        }
    }
    
    public func getTextColor() -> UIColor {
        switch self {
        case .light: return SFAssets.black
        case .dark: return SFAssets.white
        }
    }
    
    public func getAlternativeColors() -> UIColor {
        switch self {
        case .light: return SFAssets.alternativeWhite
        case .dark: return SFAssets.alternativeBlack
        }
    }
    
    public func getTextEntryColor() -> UIColor {
        switch self {
        case .light: return SFAssets.contrastWhite
        case .dark: return SFAssets.contrastBlack
        }
    }
    
    public func getPlaceholderColor() -> UIColor {
        switch self {
        case .light: return SFAssets.darkGray
        case .dark: return SFAssets.lightGray
        }
    }
    
    public func getSeparatorColor() -> UIColor {
        switch self {
        case .light: return SFAssets.separatorWhite
        case .dark: return SFAssets.separatorBlack
        }
    }
    
    public func getInteractiveColor() -> UIColor {
        switch self {
        case .light: return SFAssets.blue
        case .dark: return SFAssets.orange
        }
    }
    
}





















