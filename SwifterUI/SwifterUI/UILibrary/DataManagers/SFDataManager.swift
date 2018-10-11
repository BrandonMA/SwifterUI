//
//  SFDataManager.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/22/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

public protocol SFDataManagerDelegate: class {
    func insertSection(at index: Int)
    func moveSection(from: Int, to: Int)
    func deleteSection(at index: Int)
    func updateSection(at index: Int)
    func insertItem(at indexPath: IndexPath)
    func moveItem(from: IndexPath, to: IndexPath)
    func deleteItem(at indexPath: IndexPath)
    func updateItem(at index: IndexPath)
    func updateSection<DataType: Hashable>(with changes: [Change<DataType>], index: Int)
    func forceUpdate()
}

open class SFDataManager<DataType: Hashable> {
    
    // MARK: - Instance Properties
    
    public typealias ContentType = [SFDataSection<DataType>]
    private var iterator: Int = 0
    
    /**
     Main storage of data, you should not modify it directly.
     */
    public final var data: ContentType = []
    public final weak var delegate: SFDataManagerDelegate?
    
    // MARK: - Instace Methods
    
    open func forceUpdate(dataSections: ContentType) {
        data = dataSections
        delegate?.forceUpdate()
    }
    
    open func forceUpdate(data: [[DataType]]) {
        self.data = data.compactMap({ return SFDataSection<DataType>(content: $0) })
        delegate?.forceUpdate()
    }
    
    @discardableResult
    public final func update(dataSections: ContentType) -> [[Change<DataType>]] {
        let changes = dataSections.enumerated().map { (index, dataSection) -> [Change<DataType>] in
            return self.update(dataSection: dataSection, index: index)
        }
        return changes
    }
    
    @discardableResult
    public final func update(data: [[DataType]]) -> [[Change<DataType>]] {
        let changes = data.enumerated().map { (index, dataSection) -> [Change<DataType>] in
            let dataSection = SFDataSection<DataType>(content: dataSection, identifier: "")
            return self.update(dataSection: dataSection, index: index)
        }
        return changes
    }

    @discardableResult
    private func update(dataSection: SFDataSection<DataType>, index: Int?) -> [Change<DataType>] {
        var changes: [Change<DataType>] = []

        if let index = index, self.data.count > index {
            let oldDataSection = self.data[index]
            changes = diff(old: oldDataSection.content, new: dataSection.content)
            self.data[index] = dataSection
            delegate?.updateSection(with: changes, index: index)
        } else {
            insertSection(dataSection, at: nextLastSectionIndex)
        }
        
        return changes
    }
}

// MARK: - Collection && IteratorProtocol

extension SFDataManager: Collection, IteratorProtocol {

    public typealias Element = ContentType.Element
    public typealias Index = ContentType.Index

    public var startIndex: Index { return data.startIndex }
    public var endIndex: Index { return data.endIndex }
    
    public subscript(index: Index) -> ContentType.Element {
        return data[index]
    }
    
    public func index(after i: Index) -> Index {
        return data.index(after: i)
    }
    
    public func next() -> SFDataSection<DataType>? {
        if iterator == count {
            return nil
        } else {
            defer { iterator += 1 }
            return data[iterator]
        }
    }
    
    public func contains(_ element: DataType) -> Bool {
        return contains { return $0.contains(element) }
    }
    
}

// MARK: - Computed Properties

public extension SFDataManager {
    
    public final var flatData: [DataType] { return data.flatMap { return $0.content } }
    
    public var lastSectionIndex: Int { return count == 0 ? 0 : count - 1 }
    public var nextLastSectionIndex: Int { return count == 0 ? 0 : count }
    
    public var lastItemIndex: IndexPath {
        if count == 0 {
            return IndexPath(item: 0, section: 0)
        } else {
            let lastSection = data[lastSectionIndex]
            let lastItemIndex = lastSection.count == 0 ? 0 : lastSection.count - 1
            return IndexPath(item: lastItemIndex, section: lastSectionIndex)
        }
    }
    
    public var nextLastItemIndex: IndexPath {
        
        if count == 0 {
            return IndexPath(item: 0, section: 0)
        } else {
            var nextLastItemIndex = lastItemIndex
            nextLastItemIndex.item += 1
            return nextLastItemIndex
        }
    }
    
    public var last: SFDataSection<DataType>? {
        return data.last
    }
    
    public var lastItem: DataType? {
        if isEmpty {
            return nil
        } else {
            let item = data[lastItemIndex.section].content[lastItemIndex.row]
            return item
        }
    }
    
}

// MARK: - Sections

public extension SFDataManager {
    
    public func insertSection(_ section: SFDataSection<DataType>, at index: Int? = nil) {
        let index = index ?? lastSectionIndex
        data.insert(section, at: index)
        delegate?.insertSection(at: index)
    }
    
    public func moveSection(from: Int, to: Int) {
        data.move(from: from, to: to)
        delegate?.moveSection(from: from, to: to)
    }
    
    public func deleteSection(at index: Int) {
        data.remove(at: index)
        delegate?.deleteSection(at: index)
    }
    
    public func updateSection(_ section: SFDataSection<DataType>? = nil, at index: Int) {
        
        if let section = section {
            data[index] = section
        }
        
        delegate?.updateSection(at: index)
    }
}

// MARK: - Items

public extension SFDataManager {
    
    public func insertItem(_ item: DataType, at indexPath: IndexPath? = nil) {
        let indexPath = indexPath ?? nextLastItemIndex
        
        if indexPath.section > self.lastSectionIndex || count == 0 {
            insertSection(SFDataSection<DataType>(), at: lastSectionIndex)
        }
        
        data[indexPath.section].content.insert(item, at: indexPath.row)
        delegate?.insertItem(at: indexPath)
    }
    
    public func moveItem(from: IndexPath, to: IndexPath) {
        let item = data[from.section].content[from.item] // Get item to move
        data[from.section].content.remove(at: from.item) // Remove it from old indexPath
        data[to.section].content.insert(item, at: to.item) // Insert it to new indexPath
        delegate?.moveItem(from: from, to: to)
    }
    
    public func deleteItem(at indexPath: IndexPath) {
        data[indexPath.section].content.remove(at: indexPath.item)
        delegate?.deleteItem(at: indexPath)
    }
    
    public func updateItem(_ item: DataType? = nil, at indexPath: IndexPath) {
        if let item = item {
            data[indexPath.section].content[indexPath.row] = item
        }
        delegate?.updateItem(at: indexPath)
    }
    
    public func getItem(at indexPath: IndexPath) -> DataType {
        return data[indexPath.section].content[indexPath.row]
    }
    
    public func deleteItem(_ item: DataType) {
        for (sectionIndex, section) in enumerated() {
            for (itemIndex, sectionItem) in section.enumerated() where item == sectionItem {
                self.deleteItem(at: IndexPath(item: itemIndex, section: sectionIndex))
                return
            }
        }
    }
    
}
