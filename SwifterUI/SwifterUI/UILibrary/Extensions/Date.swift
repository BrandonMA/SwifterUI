//
//  DateExtensions.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 26/09/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

public extension Date {
    
    // MARK: - Static Methods
    
    public static func today(with format: String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // MARK: - Instance Methods
    
    public func string(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    public func getHour() -> String {
        let calendar = Calendar.current
        var hour = "\(calendar.component(.hour, from: self))"
        var minute = "\(calendar.component(.minute, from: self))"
        
        if hour.count == 1 {
            hour = "0\(hour)"
        }
        
        if minute.count == 1 {
            minute = "0\(minute)"
        }
        
        return "\(hour):\(minute)"
    }
}
