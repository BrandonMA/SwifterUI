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
    func headerStyler<HeaderType: SFTableViewHeaderView, DataType: Hashable>() -> ((HeaderType, SFDataSection<DataType>, Int) -> ())?
    func footerStyler<FooterType: SFTableViewFooterView, DataType: Hashable>() -> ((FooterType, SFDataSection<DataType>, Int) -> ())?
    func prefetch<DataType: Hashable>(item: DataType, indexPath: IndexPath)
}

public extension SFTableAdapterDelegate {
    public func didSelectRow<DataType: Hashable>(at indexPath: IndexPath, tableView: SFTableView, item: DataType) {}
    public func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat? { return nil }
    public func headerStyler<HeaderType: SFTableViewHeaderView, DataType: Hashable>() -> ((HeaderType, SFDataSection<DataType>, Int) -> ())? { return nil }
    public func footerStyler<FooterType: SFTableViewFooterView, DataType: Hashable>() -> ((FooterType, SFDataSection<DataType>, Int) -> ())? { return nil }
    public func prefetch<DataType: Hashable>(item: DataType, indexPath: IndexPath) {}
}

open class SFTableAdapter<DataType: Hashable, CellType: SFTableViewCell, HeaderType: SFTableViewHeaderView, FooterType: SFTableViewFooterView>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Instance Properties
    
    public final weak var delegate: SFTableAdapterDelegate?
    public final weak var tableView: SFTableView?
    public final weak var dataManager: SFDataManager<DataType>?
    
    public final var insertAnimation: UITableView.RowAnimation = .automatic
    public final var deleteAnimation: UITableView.RowAnimation = .automatic
    public final var reloadAnimation: UITableView.RowAnimation = .automatic
    
    public final var addIndexList: Bool = false
    
    public func configure(tableView: SFTableView, dataManager: SFDataManager<DataType>) {
        self.dataManager = dataManager
        self.tableView = tableView
        dataManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        registerViews()
        registerHeightForViews()
    }
    
    private final func registerViews() {
        tableView?.register(CellType.self, forCellReuseIdentifier: CellType.identifier)
        tableView?.register(HeaderType.self, forHeaderFooterViewReuseIdentifier: HeaderType.identifier)
        tableView?.register(FooterType.self, forHeaderFooterViewReuseIdentifier: FooterType.identifier)
    }
    
    private final func registerHeightForViews() {
        
        tableView?.rowHeight = CellType.height
        
        if let _: ((HeaderType, SFDataSection<DataType>, Int) -> ()) = delegate?.headerStyler() {
            tableView?.sectionHeaderHeight = HeaderType.height
        } else {
            tableView?.sectionHeaderHeight = 0.0
        }
        
        if let _: ((FooterType, SFDataSection<DataType>, Int) -> ()) = delegate?.footerStyler() {
            tableView?.sectionFooterHeight = FooterType.height
        } else {
            tableView?.sectionFooterHeight = 0.0
        }
        
        if tableView?.style == .grouped {
            tableView?.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
            tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if addIndexList {
            return dataManager?.compactMap({ $0.identifier })
        } else {
            return nil
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataManager = dataManager else { return 0 }
        return dataManager.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataManager = dataManager else { return 0 }
        return dataManager[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType else { return UITableViewCell() }
        guard let dataManager = dataManager else { return UITableViewCell() }
        delegate?.prepareCell(cell, at: indexPath, with: dataManager.getItem(at: indexPath))
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? SFTableView else { return }
        guard let dataManager = dataManager else { return }
        let item = dataManager[indexPath.section].content[indexPath.row]
        delegate?.didSelectRow(at: indexPath, tableView: tableView, item: item)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableView = self.tableView else { return 0 }
        return delegate?.heightForRow(at: indexPath, tableView: tableView) ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _: ((HeaderType, SFDataSection<DataType>, Int) -> ()) = delegate?.headerStyler() {
            return HeaderType.height
        } else {
            return 0.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerStyle: ((HeaderType, SFDataSection<DataType>, Int) -> ()) = delegate?.headerStyler() {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderType.identifier) as? HeaderType else { return nil }
            guard let dataManager = dataManager else { return nil }
            headerStyle(view, dataManager[section], section)
            view.updateColors()
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let _: ((FooterType, SFDataSection<DataType>, Int) -> ()) = delegate?.footerStyler() {
            return FooterType.height
        } else {
            return 0.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if let footerStyle: ((FooterType, SFDataSection<DataType>, Int) -> ()) = delegate?.footerStyler() {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterType.identifier) as? FooterType else { return nil }
            guard let dataManager = dataManager else { return nil }
            footerStyle(view, dataManager[section], section)
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
            delegate?.prefetch(item: dataManager.getItem(at: indexPath), indexPath: indexPath)
        }
    }

    
}

extension SFTableAdapter: SFDataManagerDelegate {
    
    public func updateSection<DataType>(with changes: [Change<DataType>], index: Int) where DataType : Hashable {
        tableView?.reload(changes: changes, section: index, insertionAnimation: insertAnimation, deletionAnimation: deleteAnimation, replacementAnimation: .automatic, completion: { (_) in
            
        })
    }
    
    public func forceUpdate() {
        tableView?.reloadData()
    }
    
    // MARK: - Sections
    
    public func insertSection(at index: Int) {
        tableView?.performBatchUpdates({
            tableView?.insertSections(IndexSet(integer: index), with: .automatic)
        }, completion: nil)
    }
    
    public func moveSection(from: Int, to: Int) {
        tableView?.performBatchUpdates({
            tableView?.moveSection(from, toSection: to)
        }, completion: nil)
    }
    
    public func removeSection(at index: Int) {
        tableView?.performBatchUpdates({
            tableView?.deleteSections(IndexSet(integer: index), with: deleteAnimation)
        }, completion: nil)
    }
    
    // MARK: - Items
    
    public func insertItem(at indexPath: IndexPath) {
        tableView?.performBatchUpdates({
            tableView?.insertRows(at: [indexPath], with: .automatic)
        }, completion: nil)
    }
    
    public func moveItem(from: IndexPath, to: IndexPath) {
        tableView?.performBatchUpdates({
            tableView?.moveRow(at: from, to: to)
        }, completion: nil)
    }
    
    public func removeItem(at indexPath: IndexPath) {
        tableView?.performBatchUpdates({
            tableView?.deleteRows(at: [indexPath], with: deleteAnimation)
        }, completion: nil)
    }
}





























