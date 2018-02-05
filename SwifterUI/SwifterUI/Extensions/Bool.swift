//
//  Bool.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

public extension Bool {
    public mutating func toggle() {
        self = self == true ? false : true
    }
}
