//
//  SFCollectionManager.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 07/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff
import PromiseKit

open class SFCollectionManager<DataModel: Hashable, CellType: SFCollectionViewCell>: NSObject, UICollectionViewDataSource {
    
    // MARK: - Instance Properties
    
    private var data: [SFDataSection<DataModel>] = [SFDataSection<DataModel>()]
    public weak var collectionView: SFCollectionView?
    
    public var lastSectionIndex: Int {
        return data.count == 0 ? data.count : data.count - 1
    }
    
    public var lastIndex: IndexPath {
        return data[lastSectionIndex].content.count == 0 ? IndexPath(row: 0, section: lastSectionIndex) : IndexPath(row: data[lastSectionIndex].content.count, section: lastSectionIndex)
    }
    
    open var cellHandler: ((CellType, DataModel, IndexPath) -> ())? = nil
    
    // MARK: - Initializers
    
    public init(dataSections: [SFDataSection<DataModel>] = []) {
        super.init()
        update(dataSections: dataSections)
    }
    
    public init(data: [[DataModel]] = []) {
        super.init()
        update(data: data)
    }
    
    // MARK: - Instace Methods
    
    open func configure(collectionView: SFCollectionView) {
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.identifier)
    }
    
    open func update(dataSections: [SFDataSection<DataModel>]) {
        for (index, section) in dataSections.enumerated() {
            DispatchQueue.addAsyncTask(to: .main) {
                self.update(dataSection: section, index: index)
            }
        }
    }
    
    open func update(data: [[DataModel]]) {
        for (index, section) in data.enumerated() {
            DispatchQueue.addAsyncTask(to: .main) {
                let dataSection = SFDataSection<DataModel>(content: section, identifier: "")
                self.update(dataSection: dataSection, index: index)
            }
        }
    }

    private func update(dataSection: SFDataSection<DataModel>, index: Int) {
        if self.data.count > index {
            let olddataSection = self.data[index]
            let changes = diff(old: olddataSection.content, new: dataSection.content)
            self.data[index] = dataSection
            self.collectionView?.reload(changes: changes, section: index, completion: { (_) in
                
            })
        } else {
            insert(section: dataSection, index: index)
        }
    }

    // MARK: - Sections
    
    @discardableResult
    open func insert(section: SFDataSection<DataModel>, index: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data.append(section)
            self.collectionView?.performBatchUpdates({
                self.collectionView?.insertSections(IndexSet(integer: index))
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func moveSection(from: Int, to: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data.move(from: from, to: to)
            self.collectionView?.performBatchUpdates({
                self.collectionView?.moveSection(from, toSection: to)
            }, completion: { (_) in
                seal(())
            })
        }
    }

    @discardableResult
    open func deleteSection(index: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data.remove(at: index)
            self.collectionView?.performBatchUpdates({
                self.collectionView?.deleteSections(IndexSet(integer: index))
            }, completion: { (_) in
                seal(())
            })
        }
    }

    @discardableResult
    open func reloadSection(index: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadSections(IndexSet(integer: index))
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    // MARK: - Items
    
    open func getItem(at indexPath: IndexPath) -> DataModel {
        return data[indexPath.section].content[indexPath.row]
    }
    
    @discardableResult
    open func insert(item: DataModel, indexPath: IndexPath? = nil) -> Guarantee<Void> {
        return Guarantee { seal in
            let indexPath = indexPath ?? self.lastIndex
            if indexPath.section > self.lastSectionIndex {
                self.data.insert(SFDataSection<DataModel>(), at: self.lastSectionIndex)
            }
            self.data[indexPath.section].content.insert(item, at: indexPath.row)
            
            if self.collectionView?.numberOfItems(inSection: indexPath.section) != self.data[indexPath.section].content.count {
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertItems(at: [indexPath])
                }, completion: { (_) in
                    seal(())
                })
            }
        }
    }

    @discardableResult
    open func moveItem(from: IndexPath, to: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            let item = self.data[from.section].content[from.item] // Get item to move
            self.data[from.section].content.remove(at: from.item) // Remove it from old indexPath
            self.data[to.section].content.insert(item, at: to.item) // Insert it to new indexPath
            self.collectionView?.performBatchUpdates({
                self.collectionView?.moveItem(at: from, to: to)
            }, completion: { (_) in
                seal(())
            })
        }
    }

    @discardableResult
    open func removeItem(from indexPath: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data[indexPath.section].content.remove(at: indexPath.item)
            self.collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: [indexPath])
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func reloadItem(from indexPath: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data[indexPath.section].content.remove(at: indexPath.item)
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadItems(at: [indexPath])
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    // MARK: - UIcollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].content.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType else { return UICollectionViewCell() }
        cellHandler?(cell, data[indexPath.section].content[indexPath.row], indexPath)
        return cell
    }
}
