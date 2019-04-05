//
//  Array.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 09/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import Foundation

public extension Array {
    mutating func move(from: Int, to: Int) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "Invalid Indexes")
        insert(remove(at: from), at: to)
    }
}

