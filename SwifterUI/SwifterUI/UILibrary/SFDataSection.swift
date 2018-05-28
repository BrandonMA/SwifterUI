//
//  SFDataSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 24/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public struct SFDataSection<DataModel: Hashable> {
    
    public var content: [DataModel]
    public var identifier: String
    
    public init(content: [DataModel] = [], identifier: String = "") {
        self.content = content
        self.identifier = identifier
    }
}
