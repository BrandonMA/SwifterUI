////
////  SFCollectionManager.swift
////  SwifterUI
////
////  Created by brandon maldonado alonso on 07/05/18.
////  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
////
//

import UIKit
import DeepDiff

public protocol SFCollectionAdapterDelegate: class {
    
    func didSelectCell<DataType: SFDataType>(with item: DataType, at indexPath: IndexPath, collectionView: SFCollectionView)
    
    func heightForRow(at indexPath: IndexPath, collectionView: SFCollectionView) -> CGFloat?
    
    func prepareCell<DataType: SFDataType>(_ cell: SFCollectionViewCell, at indexPath: IndexPath, with item: DataType)
    
    var useCustomHeader: Bool { get }
    
    func prepareHeader<DataType: SFDataType>(_ view: SFCollectionViewHeaderView, with section: SFDataSection<DataType>, at index: Int)
    
    var useCustomFooter: Bool { get }
    
    func prepareFooter<DataType: SFDataType>(_ view: SFCollectionViewFooterView, with section: SFDataSection<DataType>, at index: Int)
    
    func prefetch<DataType: SFDataType>(item: DataType, at indexPath: IndexPath)
    
    func deleted<DataType: SFDataType>(item: DataType, at indexPath: IndexPath)
}

public extension SFCollectionAdapterDelegate {
    
    func didSelectCell<DataType: SFDataType>(with item: DataType, at indexPath: IndexPath, collectionView: SFCollectionView) {}
    
    func heightForRow(at indexPath: IndexPath, collectionView: SFCollectionView) -> CGFloat? { return nil }
    
    var useCustomHeader: Bool { return false }
    
    func prepareHeader<DataType: SFDataType>(_ view: SFCollectionViewHeaderView, with section: SFDataSection<DataType>, at index: Int) {}
    
    var useCustomFooter: Bool { return false }
    
    func prepareFooter<DataType: SFDataType>(_ view: SFCollectionViewFooterView, with section: SFDataSection<DataType>, at index: Int) {}
    
    func prefetch<DataType: SFDataType>(item: DataType, at indexPath: IndexPath) {}
    
    func deleted<DataType: SFDataType>(item: DataType, at indexPath: IndexPath) {}
}

public final class SFCollectionAdapter
    <DataType: SFDataType, CellType: SFCollectionViewCell, HeaderType: SFCollectionViewHeaderView, FooterType: SFCollectionViewFooterView>
: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    // MARK: - Instance Properties
    
    public weak var delegate: SFCollectionAdapterDelegate?
    public weak var collectionView: SFCollectionView?
    public weak var dataManager: SFDataManager<DataType>?
    
    public var addIndexList: Bool = false
    public var enableEditing: Bool = false
    
    public func configure(collectionView: SFCollectionView, dataManager: SFDataManager<DataType>) {
        self.dataManager = dataManager
        self.collectionView = collectionView
        dataManager.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        registerViews()
    }
    
    private final func registerViews() {
        collectionView?.register(CellType.self, forCellWithReuseIdentifier: CellType.identifier)
        collectionView?.register(HeaderType.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderType.identifier)
        collectionView?.register(FooterType.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterType.identifier)
    }
    
    private var temporarySearchData: [DataType]?
    public func search(_ isIncluded: (DataType) -> Bool) {
        temporarySearchData = dataManager?.flatData.filter(isIncluded)
        collectionView?.reloadData()
    }
    
    public func clearSearch() {
        temporarySearchData = nil
        collectionView?.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let dataManager = dataManager else { return 0 }
        return temporarySearchData == nil ? dataManager.count : 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataManager = dataManager else { return 0 }
        return temporarySearchData?.count ?? dataManager[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType else {
            return UICollectionViewCell()
        }
        guard let dataManager = dataManager else { return UICollectionViewCell() }
        if let temporarySearchData = temporarySearchData {
            delegate?.prepareCell(cell, at: indexPath, with: temporarySearchData[indexPath.row])
        } else {
            delegate?.prepareCell(cell, at: indexPath, with: dataManager.getItem(at: indexPath))
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let dataManager = dataManager else { return UICollectionReusableView() }
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderType.identifier, for: indexPath) as? HeaderType else { return UICollectionReusableView() }
            reusableView.updateColors()
            delegate?.prepareHeader(reusableView, with: dataManager[indexPath.section], at: indexPath.section)
            return reusableView
        case UICollectionView.elementKindSectionFooter:
            guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterType.identifier, for: indexPath) as? FooterType else { return UICollectionReusableView() }
            delegate?.prepareFooter(reusableView, with: dataManager[indexPath.section], at: indexPath.section)
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
        guard let collectionView = collectionView as? SFCollectionView,
            let dataManager = dataManager
            else { return }
        
        if let temporarySearchData = temporarySearchData {
            let item = temporarySearchData[indexPath.row]
            delegate?.didSelectCell(with: item, at: indexPath, collectionView: collectionView)
        } else {
            let item = dataManager[indexPath.section].content[indexPath.row]
            delegate?.didSelectCell(with: item, at: indexPath, collectionView: collectionView)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if temporarySearchData != nil { return .zero }
        if let delegate = delegate {
            return delegate.useCustomHeader ? CGSize(width: collectionView.bounds.width, height: HeaderType.height) : .zero
        } else {
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if temporarySearchData != nil { return .zero }
        if let delegate = delegate {
            return delegate.useCustomHeader ? CGSize(width: collectionView.bounds.width, height: FooterType.height) : .zero
        } else {
            return .zero
        }
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let dataManager = dataManager else { return }
        indexPaths.forEach { (indexPath) in
            delegate?.prefetch(item: dataManager[indexPath.section].content[indexPath.row], at: indexPath)
        }
    }
}

extension SFCollectionAdapter: SFDataManagerDelegate {
    
    public func updateSection<DataType>(with changes: [Change<DataType>], index: Int) where DataType: SFDataType {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.reload(changes: changes, section: index, updateData: {
                
            }, completion: nil)
        }
        
    }
    
    public func forceUpdate() {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.reloadData()
        }
    }
    
    // MARK: - Sections
    
    public func insertSection(at index: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.insertSections(IndexSet(integer: index))
            }, completion: nil)
        }
    }
    
    public func moveSection(from: Int, to: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.moveSection(from, toSection: to)
            }, completion: nil)
        }
    }
    
    public func deleteSection(at index: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.deleteSections(IndexSet(integer: index))
            }, completion: nil)
        }
    }
    
    public func updateSection(at index: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.reloadSections(IndexSet(integer: index))
            }, completion: nil)
        }
    }
    
    // MARK: - Items
    
    public func insertItem(at indexPath: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    public func moveItem(from: IndexPath, to: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.moveItem(at: from, to: to)
            }, completion: nil)
        }
    }
    
    public func deleteItem(at indexPath: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    public func updateItem(at index: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            collectionView?.performBatchUpdates({
                collectionView?.reloadItems(at: [index])
            }, completion: nil)
        }
    }
}
