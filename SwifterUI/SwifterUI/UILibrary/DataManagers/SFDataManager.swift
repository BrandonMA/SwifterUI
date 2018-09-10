//
//  SFDataManager.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/22/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

open class SFDataManager<DataType: Hashable>: NSObject {
    
    // MARK: - Instance Properties
    
    /**
     Main storage of data, you should not modify it directly.
     */
    public final var data: [SFDataSection<DataType>] = []
    
    public final var lastSectionIndex: Int {
        return data.count == 0 ? 0 : data.count - 1
    }
    
    public final var lastItemIndex: IndexPath {
        let lastSection = data[lastSectionIndex]
        let lastItemIndex = lastSection.content.count == 0 ? 0 : lastSection.content.count - 1
        return IndexPath(item: lastItemIndex, section: lastSectionIndex)
    }
    
    public final var nextLastItemIndex: IndexPath {
        var nextLastItemIndex = lastItemIndex
        nextLastItemIndex.item += 1
        return nextLastItemIndex
    }
    
    public final var flatData: [DataType] {
        return data.flatMap { return $0.content }
    }
    
    // MARK: - Instace Methods    
    
    public final func contains(object: DataType) -> Bool {
        for section in data {
            if section.content.contains(object) {
                return true
            }
        }
        return false
    }
    
    public final func indexOf(item: DataType) -> IndexPath? {
        for (sectionIndex, section) in data.enumerated() {
            if let itemIndex = section.content.index(of: item) {
                return IndexPath(item: itemIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
    open func forceUpdate(dataSections: [SFDataSection<DataType>]) {
        data = dataSections
    }
    
    open func forceUpdate(data: [[DataType]]) {
        data.enumerated().forEach { (index, section) in
            let dataSection = SFDataSection<DataType>(content: section)
            self.data[index] = dataSection
        }
    }
    
    /**
     Main function to calculate changes on every data section, always calculate changes on the background thread and return a Guarantee on the main thread.
     */
    @discardableResult
    public final func update(dataSection: SFDataSection<DataType>, index: Int?) -> [Change<DataType>] {
        var changes: [Change<DataType>] = []
        
        if let index = index, self.data.count > index {
            let oldDataSection = self.data[index]
            changes = diff(old: oldDataSection.content, new: dataSection.content)
            self.data[index] = dataSection
        } else {
            self.data.append(dataSection)
        }
        return changes
    }
    
    /**
     Update multiple data sections at once and return all changes inside an array.
     */
    @discardableResult
    public final func update(dataSections: [SFDataSection<DataType>]) -> [[Change<DataType>]] {
        let changes = dataSections.enumerated().map { (index, dataSection) -> [Change<DataType>] in
            return self.update(dataSection: dataSection, index: index)
        }
        return changes
    }
    
    /**
     Update multiple data sections at once and return all changes inside an array.
     */
    @discardableResult
    public final func update(data: [[DataType]]) -> [[Change<DataType>]] {
        let changes = data.enumerated().map { (index, dataSection) -> [Change<DataType>] in
            let dataSection = SFDataSection<DataType>(content: dataSection, identifier: "")
            return self.update(dataSection: dataSection, index: index)
        }
        return changes
    }
}








