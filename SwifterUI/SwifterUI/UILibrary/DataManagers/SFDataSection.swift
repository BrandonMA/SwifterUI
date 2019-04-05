//
//  SFDataSection.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 24/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

public protocol SFDataType: DiffAware, Hashable {}
public extension SFDataType {
    var diffId: Int { return hashValue }
    func compareContent(_ a: String, _ b: String) -> Bool {
        return a == b
    }
}

public final class SFDataSection<DataType: SFDataType> {
    
    // MARK: - Instance Properties
    
    public typealias ContentType = [DataType]
    private var iterator: Int = 0
    
    public var content: [DataType]
    public var identifier: String
    
    // MARK: - Initializers
    
    public init(content: [DataType] = [], identifier: String = "") {
        self.content = content
        self.identifier = identifier
    }
    
}

// MARK: - Collection && IteratorProtocol

extension SFDataSection: Collection, IteratorProtocol {
    
    public typealias Element = ContentType.Element
    public typealias Index = ContentType.Index
    
    public var startIndex: Index { return content.startIndex }
    public var endIndex: Index { return content.endIndex }
    
    public subscript(index: Index) -> ContentType.Element {
        return content[index]
    }
    
    public func index(after i: Index) -> Index {
        return content.index(after: i)
    }
    
    public func next() -> DataType? {
        if iterator == content.count {
            return nil
        } else {
            defer { iterator += 1 }
            return content[iterator]
        }
    }
    
}
