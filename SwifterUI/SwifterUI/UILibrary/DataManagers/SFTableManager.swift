//
//  SFTableManager.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 30/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import DeepDiff

public protocol SFTableAdapterDelegate: class {
    
    func didSelectRow<DataType: Hashable>(at indexPath: IndexPath, tableView: SFTableView, item: DataType)
    
    func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat?
    
    func prepareCell<DataType: Hashable>(_ cell: SFTableViewCell, at indexPath: IndexPath, with data: DataType)
    
    var useCustomHeader: Bool { get }
    
    func prepareHeader<DataType: Hashable>(_ view: SFTableViewHeaderView, with data: SFDataSection<DataType>, index: Int)
    var useCustomFooter: Bool { get }
    
    func prepareFooter<DataType: Hashable>(_ view: SFTableViewFooterView, with data: SFDataSection<DataType>, index: Int)
    
    func prefetch<DataType: Hashable>(item: DataType, at indexPath: IndexPath)
    
    func deleted<DataType: Hashable>(item: DataType, at indexPath: IndexPath)
}

public extension SFTableAdapterDelegate {
    
    public func didSelectRow<DataType: Hashable>(at indexPath: IndexPath, tableView: SFTableView, item: DataType) {}
    
    public func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat? { return nil }
    
    public func prepareCell<DataType: Hashable>(_ cell: SFTableViewCell, at indexPath: IndexPath, with data: DataType) {}
    
    public var useCustomHeader: Bool { return false }
    
    public func prepareHeader<DataType: Hashable>(_ view: SFTableViewHeaderView, with data: SFDataSection<DataType>, index: Int) {}
    
    public var useCustomFooter: Bool { return false }
    
    public func prepareFooter<DataType: Hashable>(_ view: SFTableViewFooterView, with data: SFDataSection<DataType>, index: Int) {}
    
    public func prefetch<DataType: Hashable>(item: DataType, at indexPath: IndexPath) {}
    
    public func deleted<DataType: Hashable>(item: DataType, at indexPath: IndexPath) {}
}

public final class SFTableAdapter
<DataType: Hashable, CellType: SFTableViewCell, HeaderType: SFTableViewHeaderView, FooterType: SFTableViewFooterView>
: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Instance Properties
    
    public weak var delegate: SFTableAdapterDelegate? {
        didSet {
            registerHeightForViews()
        }
    }
    public weak var tableView: SFTableView?
    public weak var dataManager: SFDataManager<DataType>?
    
    public var insertAnimation: UITableView.RowAnimation = .automatic
    public var deleteAnimation: UITableView.RowAnimation = .automatic
    public var updateAnimation: UITableView.RowAnimation = .automatic
    
    public var addIndexList: Bool = false
    public var enableEditing: Bool = false
    
    public func configure(tableView: SFTableView, dataManager: SFDataManager<DataType>) {
        self.dataManager = dataManager
        self.tableView = tableView
        dataManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        registerViews()
        registerHeightForViews()
    }
    
    private func registerViews() {
        tableView?.register(CellType.self, forCellReuseIdentifier: CellType.identifier)
        tableView?.register(HeaderType.self, forHeaderFooterViewReuseIdentifier: HeaderType.identifier)
        tableView?.register(FooterType.self, forHeaderFooterViewReuseIdentifier: FooterType.identifier)
    }
    
    private func registerHeightForViews() {
        
        tableView?.rowHeight = CellType.height
        
        if let delegate = delegate {
            tableView?.sectionHeaderHeight = delegate.useCustomHeader ? HeaderType.height : 0.0
            tableView?.sectionFooterHeight = delegate.useCustomFooter ? FooterType.height : 0.0
        }
        
        if tableView?.style == .grouped {
            // Create a frame close to zero, but no 0 because there is a bug in UITableView(or feature?)
            let frame = CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude)
            tableView?.tableHeaderView = UIView(frame: frame)
            tableView?.tableFooterView = UIView(frame: frame)
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
    }
    
    private var temporarySearchData: [DataType]?
    public func search(_ isIncluded: (DataType) -> Bool) {
        temporarySearchData = dataManager?.flatData.filter(isIncluded)
        tableView?.reloadData()
    }
    
    public func clearSearch() {
        temporarySearchData = nil
        tableView?.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if temporarySearchData != nil { return nil }
        if addIndexList {
            return dataManager?.compactMap({ $0.identifier })
        } else {
            return nil
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataManager = dataManager else { return 0 }
        return temporarySearchData == nil ? dataManager.count : 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataManager = dataManager else { return 0 }
        return temporarySearchData?.count ?? dataManager[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType else {
            return UITableViewCell()
        }
        guard let dataManager = dataManager else { return UITableViewCell() }
        if let temporarySearchData = temporarySearchData {
            delegate?.prepareCell(cell, at: indexPath, with: temporarySearchData[indexPath.row])
        } else {
            delegate?.prepareCell(cell, at: indexPath, with: dataManager.getItem(at: indexPath))
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return temporarySearchData != nil ? false : enableEditing
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = dataManager?.getItem(at: indexPath)
            dataManager?.deleteItem(at: indexPath)
            delegate?.deleted(item: item, at: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? SFTableView else { return }
        guard let dataManager = dataManager else { return }
        if let temporarySearchData = temporarySearchData {
            let item = temporarySearchData[indexPath.row]
            delegate?.didSelectRow(at: indexPath, tableView: tableView, item: item)
        } else {
            let item = dataManager[indexPath.section].content[indexPath.row]
            delegate?.didSelectRow(at: indexPath, tableView: tableView, item: item)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableView = self.tableView else { return 0 }
        return delegate?.heightForRow(at: indexPath, tableView: tableView) ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if temporarySearchData != nil { return 0.0 }
        if let delegate = delegate {
            return delegate.useCustomHeader ? HeaderType.height : 0.0
        } else {
            return 0.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let delegate = delegate else { return nil }
        if temporarySearchData != nil { return nil }
        if delegate.useCustomHeader {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderType.identifier) as? HeaderType else {
                return nil
            }
            guard let dataManager = dataManager else { return nil }
            delegate.prepareHeader(view, with: dataManager[section], index: section)
            view.updateColors()
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if temporarySearchData != nil { return 0.0 }
        if let delegate = delegate {
            return delegate.useCustomFooter ? FooterType.height : 0.0
        } else {
            return 0.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let delegate = delegate else { return nil }
        if temporarySearchData != nil { return nil }
        if delegate.useCustomFooter {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterType.identifier) as? FooterType else {
                return nil
            }
            guard let dataManager = dataManager else { return nil }
            delegate.prepareFooter(view, with: dataManager[section], index: section)
            view.updateColors()
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as? HeaderType
        view?.updateColors()
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let view = view as? FooterType
        view?.updateColors()
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let dataManager = dataManager else { return }
        indexPaths.forEach { (indexPath) in
            delegate?.prefetch(item: dataManager.getItem(at: indexPath), at: indexPath)
        }
    }

}

extension SFTableAdapter: SFDataManagerDelegate {
    
    public func updateSection<DataType>(with changes: [Change<DataType>], index: Int) where DataType: Hashable {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.reload(changes: changes,
                              section: index,
                              insertionAnimation: insertAnimation,
                              deletionAnimation: deleteAnimation,
                              replacementAnimation: updateAnimation,
                              completion: { (_) in
            })
        }
        
    }
    
    public func forceUpdate() {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.reloadData()
        }
    }
    
    // MARK: - Sections
    
    public func insertSection(at index: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.insertSections(IndexSet(integer: index), with: insertAnimation)
            }, completion: nil)
        }
    }
    
    public func moveSection(from: Int, to: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.moveSection(from, toSection: to)
            }, completion: nil)
        }
    }
    
    public func deleteSection(at index: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.deleteSections(IndexSet(integer: index), with: deleteAnimation)
            }, completion: nil)
        }
    }
    
    public func updateSection(at index: Int) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.reloadSections(IndexSet(integer: index), with: updateAnimation)
            }, completion: nil)
        }
    }
    
    // MARK: - Items
    
    public func insertItem(at indexPath: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.insertRows(at: [indexPath], with: insertAnimation)
            }, completion: nil)
        }
    }
    
    public func moveItem(from: IndexPath, to: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.moveRow(at: from, to: to)
            }, completion: nil)
        }
    }
    
    public func deleteItem(at indexPath: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.deleteRows(at: [indexPath], with: deleteAnimation)
            }, completion: nil)
        }
    }
    
    public func updateItem(at index: IndexPath) {
        if temporarySearchData != nil {
            clearSearch()
        } else {
            tableView?.performBatchUpdates({
                tableView?.reloadRows(at: [index], with: updateAnimation)
            }, completion: nil)
        }
    }
}
