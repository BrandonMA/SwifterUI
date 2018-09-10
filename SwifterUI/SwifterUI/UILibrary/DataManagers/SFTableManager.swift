//
//  SFTableManager.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 30/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit
import DeepDiff

public extension UITableView {
    
    fileprivate func reload<T>(changes: [Change<T>], section: Int, insertionAnimation: UITableViewRowAnimation = .fade, deletionAnimation: UITableViewRowAnimation = .fade, replacementAnimation: UITableViewRowAnimation = .fade) -> Guarantee<Void> where T : Hashable {
        return Guarantee { seal in
            reload(changes: changes, section: section, insertionAnimation: insertionAnimation, deletionAnimation: deletionAnimation, replacementAnimation: replacementAnimation, completion: { (_) in
                seal(())
            })
        }
    }
}

public protocol SFTableManagerDelegate: class {
    func didSelectRow<DataType: Hashable>(at indexPath: IndexPath, tableView: SFTableView, item: DataType)
    func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat?
}

public extension SFTableManagerDelegate {
    public func didSelectRow<DataType: Hashable>(at indexPath: IndexPath, tableView: SFTableView, item: DataType) {}
    public func heightForRow(at indexPath: IndexPath, tableView: SFTableView) -> CGFloat? { return nil }
}

open class SFTableManager<DataType: Hashable, CellType: SFTableViewCell, HeaderType: SFTableViewHeaderView, FooterType: SFTableViewFooterView>: SFDataManager<DataType>, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    public typealias SFTableManagerItemStyler = ((CellType, DataType, IndexPath) -> ())
    public typealias SFTableManagerPrefetchStyler = ((DataType, IndexPath) -> ())
    public typealias SFTableManagerHeaderStyler = ((HeaderType, SFDataSection<DataType>, Int) -> ())
    public typealias SFTableManagerFooterStyler = ((FooterType, SFDataSection<DataType>, Int) -> ())
    
    // MARK: - Instance Properties
    
    public final weak var delegate: SFTableManagerDelegate?
    
    public final weak var tableView: SFTableView?
    
    public final var addIndexList: Bool = false
    
    /**
     Use this to style a cell with colors and less demaning tasks.
     */
    public final var cellStyler: SFTableManagerItemStyler?
    /**
     Add any prefetch calculations or tasks that could be done on the background.
     */
    public final var prefetchStyler: SFTableManagerPrefetchStyler?
    public final var headerStyler: SFTableManagerHeaderStyler?
    public final var footerStyler: SFTableManagerFooterStyler?
    
    // MARK: - Initializers
    
    // MARK: - Instace Methods
    
    open func configure(tableView: SFTableView, cellStyler: SFTableManagerItemStyler?) {
        self.cellStyler = cellStyler
        self.tableView = tableView
        tableView.dataSource = self
        tableView.prefetchDataSource = self
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
        tableView?.sectionHeaderHeight = headerStyler == nil ? 0.0 : HeaderType.height
        tableView?.sectionFooterHeight = footerStyler == nil ? 0.0 : FooterType.height
        
        if tableView?.style == .grouped {
            tableView?.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
            tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
    }
    
    // MARK: - Update Methods
    
    open override func forceUpdate(dataSections: [SFDataSection<DataType>]) {
        super.forceUpdate(dataSections: dataSections)
        tableView?.reloadData()
    }
    
    open override func forceUpdate(data: [[DataType]]) {
        super.forceUpdate(data: data)
        tableView?.reloadData()
    }
    
    @discardableResult
    open func updateSections(dataSections: [SFDataSection<DataType>], insertionAnimation: UITableViewRowAnimation = .fade, deletionAnimation: UITableViewRowAnimation = .fade, replacementAnimation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        
        if dataSections.isEmpty {
            self.data.removeAll()
            self.tableView?.reloadData()
            return Guarantee()
        } else if let item = dataSections.first, item.content.isEmpty {
            self.data.removeAll()
            self.tableView?.reloadData()
            return Guarantee()
        } else {
            return performChanges(update(dataSections: dataSections), insertionAnimation: insertionAnimation, deletionAnimation: deletionAnimation, replacementAnimation: replacementAnimation)
        }
    }
    
    @discardableResult
    open func updateSections(data: [[DataType]], insertionAnimation: UITableViewRowAnimation = .fade, deletionAnimation: UITableViewRowAnimation = .fade, replacementAnimation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        
        if data.isEmpty {
            self.data.removeAll()
            self.tableView?.reloadData()
            return Guarantee()
        } else if let item = data.first, item.isEmpty {
            self.data.removeAll()
            self.tableView?.reloadData()
            return Guarantee()
        } else {
            return performChanges(update(data: data), insertionAnimation: insertionAnimation, deletionAnimation: deletionAnimation, replacementAnimation: replacementAnimation)
        }
    }
    
    public final func performChanges(_ changes: [[Change<DataType>]], insertionAnimation: UITableViewRowAnimation = .fade, deletionAnimation: UITableViewRowAnimation = .fade, replacementAnimation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        let promises = changes.enumerated().map({ (index, changes) -> Guarantee<Void> in
            if self.tableView!.numberOfSections < self.data.count {
                return self.insertSection(index: index, animation: insertionAnimation)
            } else {
                return self.tableView!.reload(changes: changes, section: index, insertionAnimation: insertionAnimation, deletionAnimation: deletionAnimation, replacementAnimation: replacementAnimation)
            }
        })
        
        return when(guarantees: promises)
    }
    
    @discardableResult
    open func updateSection(_ dataSection: SFDataSection<DataType>, index: Int, insertionAnimation: UITableViewRowAnimation = .fade, deletionAnimation: UITableViewRowAnimation = .fade, replacementAnimation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        if self.data.count > index {
            let changes = update(dataSection: dataSection, index: index)
            return tableView!.reload(changes: changes, section: index, insertionAnimation: insertionAnimation, deletionAnimation: deletionAnimation, replacementAnimation: replacementAnimation)
        } else {
            return insertSection(dataSection)
        }
    }
    
    // MARK: - Sections
    
    @discardableResult
    open func insertSection(_ section: SFDataSection<DataType>? = nil, index: Int? = nil, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                if let section = section {
                    self.data.insert(section, at: index ?? lastSectionIndex)
                }
                self.tableView?.insertSections(IndexSet(integer: index ?? lastSectionIndex), with: animation)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func moveSection(from: Int, to: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                self.data.move(from: from, to: to)
                self.tableView?.moveSection(from, toSection: to)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func deleteSection(index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                self.data.remove(at: index)
                self.tableView?.deleteSections(IndexSet(integer: index), with: animation)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func reloadSection(index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                self.tableView?.reloadSections(IndexSet(integer: index), with: animation)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    // MARK: - Items
    
    public final func getItem(at indexPath: IndexPath) -> DataType {
        return data[indexPath.section].content[indexPath.row]
    }
    
    @discardableResult
    open func insertItem(_ item: DataType? = nil, indexPath: IndexPath? = nil, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            
            let indexPath = indexPath ?? self.nextLastItemIndex
            if indexPath.section > self.lastSectionIndex {
                self.data.insert(SFDataSection<DataType>(), at: self.lastSectionIndex)
            }
            
            self.tableView?.performBatchUpdates({
                if let item = item {
                    self.data[indexPath.section].content.insert(item, at: indexPath.row)
                }
                self.tableView?.insertRows(at: [indexPath], with: animation)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func moveItem(from: IndexPath, to: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                let item = self.data[from.section].content[from.item] // Get item to move
                self.data[from.section].content.remove(at: from.item) // Remove it from old indexPath
                self.data[to.section].content.insert(item, at: to.item) // Insert it to new indexPath
                self.tableView?.moveRow(at: from, to: to)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func removeItem(from indexPath: IndexPath, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                self.data[indexPath.section].content.remove(at: indexPath.item)
                self.tableView?.deleteRows(at: [indexPath], with: animation)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    @discardableResult
    open func reloadItem(from indexPath: IndexPath, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.performBatchUpdates({
                self.tableView?.reloadRows(at: [indexPath], with: animation)
            }, completion: { (_) in
                seal(())
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if addIndexList {
            return data.map({ $0.identifier })
        } else {
            return nil
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].content.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType else { return UITableViewCell() }
        cellStyler?(cell, data[indexPath.section].content[indexPath.row], indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? SFTableView else { return }
        let item = data[indexPath.section].content[indexPath.row]
        delegate?.didSelectRow(at: indexPath, tableView: tableView, item: item)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableView = self.tableView else { return 0 }
        return delegate?.heightForRow(at: indexPath, tableView: tableView) ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerStyler == nil ? 0.0 : HeaderType.height
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerStyle = headerStyler {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderType.identifier) as? HeaderType else { return nil }
            headerStyle(view, data[section], section)
            view.updateColors()
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerStyler == nil ? 0.0 : FooterType.height
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerStyle = footerStyler {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterType.identifier) as? FooterType else { return nil }
            footerStyle(view, data[section], section)
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
        indexPaths.forEach { (indexPath) in
            prefetchStyler?(data[indexPath.section].content[indexPath.row], indexPath)
        }
    }
    
}






























