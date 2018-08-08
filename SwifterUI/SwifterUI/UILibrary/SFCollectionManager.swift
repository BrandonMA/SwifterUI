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

public protocol SFCollectionManagerDelegate: class {
    func didSelectItem<DataModel: Hashable>(at indexPath: IndexPath, collectionView: SFCollectionView, item: DataModel)
}

open class SFCollectionManager<DataModel: Hashable, CellType: SFCollectionViewCell, HeaderType: SFCollectionViewHeaderView, FooterType: SFCollectionViewFooterView>: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    public typealias SFCollectionManagerItemStyler = ((CellType, DataModel, IndexPath) -> ())
    
    // MARK: - Instance Properties
    
    public weak var delegate: SFCollectionManagerDelegate?
    
    public var data: [SFDataSection<DataModel>] = []
    public weak var collectionView: SFCollectionView?
    
    public var lastSectionIndex: Int {
        return data.count == 0 ? data.count : data.count - 1
    }
    
    public var lastIndex: IndexPath {
        return data[lastSectionIndex].content.count == 0 ? IndexPath(row: 0, section: lastSectionIndex) : IndexPath(row: data[lastSectionIndex].content.count, section: lastSectionIndex)
    }
    
    open var itemStyler: ((CellType, DataModel, IndexPath) -> ())?
    open var prefetchStyler: ((DataModel, IndexPath) -> ())?
    open var headerStyler: ((HeaderType, SFDataSection<DataModel>, Int) -> ())?
    open var footerStyler: ((FooterType, SFDataSection<DataModel>, Int) -> ())?
    
    // MARK: - Initializers
    
    public init(dataSections: [SFDataSection<DataModel>] = []) {
        super.init()
        DispatchQueue.addAsyncTask(to: .main) {
            self.update(dataSections: dataSections)
        }
    }
    
    public init(data: [[DataModel]] = []) {
        super.init()
        DispatchQueue.addAsyncTask(to: .main) {
            self.update(data: data)
        }
    }
    
    // MARK: - Instace Methods
    
    open func configure(collectionView: SFCollectionView, itemStyler: SFCollectionManagerItemStyler?) {
        self.itemStyler = itemStyler
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        registerViews()
    }
    
    private final func registerViews() {
        collectionView?.register(CellType.self, forCellWithReuseIdentifier: CellType.identifier)
        collectionView?.register(HeaderType.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderType.identifier)
        collectionView?.register(FooterType.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FooterType.identifier)
    }
    
    // MARK: - Update Methods
    
    @discardableResult
    open func update(dataSections: [SFDataSection<DataModel>]) -> Guarantee<Void> {
        
        return Guarantee { seal in
            
            if dataSections.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal(())
            } else if let item = dataSections.first, item.content.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal(())
            } else {
                for (index, section) in dataSections.enumerated() {
                    let numberOfRowsBeforeUpdate = collectionView!.numberOfSections > 0 ? collectionView!.numberOfItems(inSection: index) : 0
                    self.update(dataSection: section, index: index).done {
                        
                        if numberOfRowsBeforeUpdate == 0 {
                            self.reloadSection(index: index)
                        }
                        
                        if index == dataSections.count - 1 {
                            seal(())
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    open func update(data: [[DataModel]]) -> Guarantee<Void> {
        return Guarantee { seal in
            
            if data.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal(())
            } else if let item = data.first, item.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal(())
            } else {
                for (index, section) in data.enumerated() {
                    let numberOfRowsBeforeUpdate = collectionView!.numberOfSections > 0 ? collectionView!.numberOfItems(inSection: index) : 0
                    let dataSection = SFDataSection<DataModel>(content: section, identifier: "")
                    self.update(dataSection: dataSection, index: index).done {
                        
                        if numberOfRowsBeforeUpdate == 0 {
                            self.reloadSection(index: index)
                        }
                        
                        if index == data.count - 1 {
                            seal(())
                        }
                    }
                }
            }
        }
    }
    
    @discardableResult
    private func update(dataSection: SFDataSection<DataModel>, index: Int) -> Guarantee<Void> {
        if self.data.count > index {
            return Guarantee { seal in
                let olddataSection = self.data[index]
                let changes = diff(old: olddataSection.content, new: dataSection.content)
                self.data[index] = dataSection
                self.collectionView?.reload(changes: changes, section: index, completion: { (_) in
                    seal(())
                })
            }
        } else {
            return insert(section: dataSection, index: index)
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
            self.collectionView?.performBatchUpdates({
                self.collectionView?.reloadItems(at: [indexPath])
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].content.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType else { return UICollectionViewCell() }
        itemStyler?(cell, data[indexPath.section].content[indexPath.row], indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderType.identifier, for: indexPath) as? HeaderType else { return UICollectionReusableView() }
            reusableView.updateColors()
            headerStyler?(reusableView, data[indexPath.section], indexPath.section)
            return reusableView
        case UICollectionElementKindSectionFooter:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterType.identifier, for: indexPath) as? FooterType else { return UICollectionReusableView() }
            footerStyler?(reusableView, data[indexPath.section], indexPath.section)
            return reusableView
        default: return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let view = view as? SFViewColorStyle
        view?.updateColors()
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionView = collectionView as? SFCollectionView else { return }
        let item = data[indexPath.section].content[indexPath.row]
        delegate?.didSelectItem(at: indexPath, collectionView: collectionView, item: item)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return headerStyler == nil ? .zero : CGSize(width: collectionView.bounds.width, height: HeaderType.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return footerStyler == nil ? .zero : CGSize(width: collectionView.bounds.width, height: FooterType.height)
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            prefetchStyler?(data[indexPath.section].content[indexPath.row], indexPath)
        }
    }
}
















