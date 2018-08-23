//
//  SFDataManager.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 8/22/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit
import DeepDiff

open class SFDataManager<DataModel: Hashable>: NSObject {
    
    // MARK: - Instance Properties
    
    /**
     Main storage of data, you should not modify it directly.
     */
    public var data: [SFDataSection<DataModel>] = []
    
    public var lastSectionIndex: Int {
        return data.count == 0 ? 0 : data.count - 1
    }
    
    public var lastItemIndex: IndexPath {
        let lastSection = data[lastSectionIndex]
        let lastItemIndex = lastSection.content.count == 0 ? 0 : lastSection.content.count - 1
        return IndexPath(item: lastItemIndex, section: lastSectionIndex)
    }
    
    public var nextLastItemIndex: IndexPath {
        var nextLastItemIndex = lastItemIndex
        nextLastItemIndex.item += 1
        return nextLastItemIndex
    }
    
    // MARK: - Instace Methods
    
    open func forceUpdate(dataSections: [SFDataSection<DataModel>]) {
        data = dataSections
    }
    
    open func forceUpdate(data: [[DataModel]]) {
        data.enumerated().forEach { (index, section) in
            let dataSection = SFDataSection<DataModel>(content: section, identifier: "")
            self.data[index] = dataSection
        }
    }
    
    /**
     Main function to calculate changes on every data section, always calculate changes on the background thread and return a Guarantee on the main thread.
     */
    @discardableResult
    open func update(dataSection: SFDataSection<DataModel>, index: Int?) -> Guarantee<[Change<DataModel>]> {
        return Guarantee { seal in
            
            var changes: [Change<DataModel>] = []
            
            if let index = index, self.data.count > index {
                let olddataSection = self.data[index]
                changes = diff(old: olddataSection.content, new: dataSection.content)
                self.data[index] = dataSection
            } else {
                self.data.append(dataSection)
            }
            
            seal(changes)
        }
    }
    
    /**
     Update multiple data sections at once and return all changes inside an array.
     */
    @discardableResult
    open func update(dataSections: [SFDataSection<DataModel>]) -> Promise<[[Change<DataModel>]]> {
        let promises = dataSections.enumerated().map { (index, dataSection) -> Guarantee<[Change<DataModel>]> in
            return self.update(dataSection: dataSection, index: index)
        }
        return when(fulfilled: promises)
    }
    
    /**
     Update multiple data sections at once and return all changes inside an array.
     */
    @discardableResult
    open func update(data: [[DataModel]]) -> Promise<[[Change<DataModel>]]> {
        let promises = data.enumerated().map { (index, dataSection) -> Guarantee<[Change<DataModel>]> in
            let dataSection = SFDataSection<DataModel>(content: dataSection, identifier: "")
            return self.update(dataSection: dataSection, index: index)
        }
        return when(fulfilled: promises)
    }
}
