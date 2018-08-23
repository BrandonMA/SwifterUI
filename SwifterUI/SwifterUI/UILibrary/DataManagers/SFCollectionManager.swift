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

public extension UICollectionView {
    
    func reload<T>(changes: [Change<T>], section: Int) -> Guarantee<Void> where T : Hashable {
        return Guarantee { seal in
            reload(changes: changes, section: section, completion: { (_) in
                seal(())
            })
        }
    }
    
}

public protocol SFCollectionManagerDelegate: class {
    func didSelectItem<DataModel: Hashable>(at indexPath: IndexPath, collectionView: SFCollectionView, item: DataModel)
}

public extension SFCollectionManagerDelegate {
    func didSelectItem<DataModel: Hashable>(at indexPath: IndexPath, collectionView: SFCollectionView, item: DataModel) {}
}

open class SFCollectionManager<DataModel: Hashable, CellType: SFCollectionViewCell, HeaderType: SFCollectionViewHeaderView, FooterType: SFCollectionViewFooterView>: SFDataManager<DataModel>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    public typealias SFCollectionManagerItemStyler = ((CellType, DataModel, IndexPath) -> ())
    public typealias SFCollectionManagerPrefetcher = ((DataModel, IndexPath) -> ())
    public typealias SFCollectionManagerHeaderStyle = ((HeaderType, SFDataSection<DataModel>, Int) -> ())
    public typealias SFCollectionManagerFooterStyle = ((FooterType, SFDataSection<DataModel>, Int) -> ())
    
    // MARK: - Instance Properties
    
    public weak var delegate: SFCollectionManagerDelegate?
    
    public weak var collectionView: SFCollectionView?
    
    open var itemStyler: SFCollectionManagerItemStyler?
    open var prefetchStyler: SFCollectionManagerPrefetcher?
    open var headerStyler: SFCollectionManagerHeaderStyle?
    open var footerStyler: SFCollectionManagerFooterStyle?
    
    // MARK: - Initializers
    
    public override init() {
        super.init()
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
    
    open override func forceUpdate(dataSections: [SFDataSection<DataModel>]) {
        super.forceUpdate(dataSections: dataSections)
        collectionView?.reloadData()
    }
    
    open override func forceUpdate(data: [[DataModel]]) {
        super.forceUpdate(data: data)
        collectionView?.reloadData()
    }
    
    @discardableResult
    open func updateSections(dataSections: [SFDataSection<DataModel>]) -> Promise<Void> {
        
        return Promise { seal in
            
            if dataSections.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal.fulfill(())
            } else if let item = dataSections.first, item.content.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal.fulfill(())
            } else {
                firstly {
                    update(dataSections: dataSections)
                }.then ({ (arrayOfChanges)  -> Promise<Void> in
                    let promises = arrayOfChanges.enumerated().map({ (index, changes) -> Guarantee<Void> in
                        if self.collectionView!.numberOfSections < self.data.count {
                            return self.insertSection(index: index)
                        } else {
                            return self.collectionView!.reload(changes: changes, section: index)
                        }
                    })
                    return when(fulfilled: promises)
                }).done({
                    seal.fulfill(())
                }).catch({ (error) in
                    seal.reject(error)
                })
            }
        }
    }
    
    @discardableResult
    open func updateSections(data: [[DataModel]]) -> Promise<Void> {
        return Promise { seal in
            
            if data.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal.fulfill(())
            } else if let item = data.first, item.isEmpty {
                self.data.removeAll()
                self.collectionView?.reloadData()
                seal.fulfill(())
            } else {
                firstly {
                    update(data: data)
                }.then ({ (arrayOfChanges)  -> Promise<Void> in
                    let promises = arrayOfChanges.enumerated().map({ (index, changes) -> Guarantee<Void> in
                        if self.collectionView!.numberOfSections < self.data.count {
                            return self.insertSection(index: index)
                        } else {
                            return self.collectionView!.reload(changes: changes, section: index)
                        }
                    })
                    return when(fulfilled: promises)
                }).done({
                    seal.fulfill(())
                }).catch({ (error) in
                    seal.reject(error)
                })
            }
        }
    }
    
    @discardableResult
    private func updateSection(dataSection: SFDataSection<DataModel>, index: Int) -> Guarantee<Void> {
        if self.data.count > index {
            return firstly {
                update(dataSection: dataSection, index: index)
            }.then { (changes) -> Guarantee<Void> in
                self.collectionView!.reload(changes: changes, section: index)
            }
        } else {
            return insertSection(dataSection, index: index)
        }
    }
    
    // MARK: - Sections
    
    @discardableResult
    open func insertSection(_ section: SFDataSection<DataModel>? = nil, index: Int? = nil) -> Guarantee<Void> {
        return Guarantee { seal in
            self.collectionView?.performBatchUpdates({
                if let section = section {
                    self.data.insert(section, at: index ?? lastSectionIndex)
                }
                self.collectionView?.insertSections(IndexSet(integer: index ?? lastSectionIndex))
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func moveSection(from: Int, to: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.collectionView?.performBatchUpdates({
                self.data.move(from: from, to: to)
                self.collectionView?.moveSection(from, toSection: to)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func deleteSection(index: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.collectionView?.performBatchUpdates({
                self.data.remove(at: index)
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
    open func insertItem(_ item: DataModel, indexPath: IndexPath? = nil) -> Guarantee<Void> {
        return Guarantee { seal in
            
            let indexPath = indexPath ?? self.nextLastItemIndex
            if indexPath.section > self.lastSectionIndex {
                self.data.insert(SFDataSection<DataModel>(), at: self.lastSectionIndex)
            }
            
            self.collectionView?.performBatchUpdates({
                self.data[indexPath.section].content.insert(item, at: indexPath.row)
                self.collectionView?.insertItems(at: [indexPath])
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func moveItem(from: IndexPath, to: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            self.collectionView?.performBatchUpdates({
                let item = self.data[from.section].content[from.item] // Get item to move
                self.data[from.section].content.remove(at: from.item) // Remove it from old indexPath
                self.data[to.section].content.insert(item, at: to.item) // Insert it to new indexPath
                self.collectionView?.moveItem(at: from, to: to)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func removeItem(from indexPath: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            self.collectionView?.performBatchUpdates({
                self.data[indexPath.section].content.remove(at: indexPath.item)
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
















