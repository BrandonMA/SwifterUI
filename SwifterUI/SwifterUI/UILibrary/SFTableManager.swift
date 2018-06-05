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

public protocol SFTableManagerDelegate: class {
    func didSelectRow<DataModel: Hashable>(at indexPath: IndexPath, tableView: SFTableView, item: DataModel)
}

open class SFTableManager<DataModel: Hashable, CellType: SFTableViewCell, HeaderType: SFTableViewHeaderView, FooterType: SFTableViewFooterView>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    public typealias SFTableManagerItemStyler = ((CellType, DataModel, IndexPath) -> ())
    
    // MARK: - Instance Properties
    
    public weak var delegate: SFTableManagerDelegate?
    
    public var data: [SFDataSection<DataModel>] = [SFDataSection<DataModel>()]
    public weak var tableView: SFTableView?
    
    public var lastSectionIndex: Int {
        return data.count == 0 ? data.count : data.count - 1
    }
    
    public var lastIndex: IndexPath {
        return data[lastSectionIndex].content.count == 0 ? IndexPath(row: 0, section: lastSectionIndex) : IndexPath(row: data[lastSectionIndex].content.count, section: lastSectionIndex)
    }
    
    open var cellStyler: ((CellType, DataModel, IndexPath) -> ())?
    open var headerStyle: ((HeaderType, SFDataSection<DataModel>, Int) -> ())?
    open var footerStyle: ((FooterType, SFDataSection<DataModel>, Int) -> ())?
    
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
    
    open func configure(tableView: SFTableView, cellStyler: SFTableManagerItemStyler?) {
        self.cellStyler = cellStyler
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.identifier)
        tableView.rowHeight = CellType.height
        
        if tableView.style == .grouped {
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        }
        
        tableView.register(HeaderType.self, forHeaderFooterViewReuseIdentifier: HeaderType.identifier)
        tableView.register(FooterType.self, forHeaderFooterViewReuseIdentifier: FooterType.identifier)
    }
    
    // MARK: - Update Methods
    
    @discardableResult
    open func update(dataSections: [SFDataSection<DataModel>], animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            for (index, section) in dataSections.enumerated() {
                update(dataSection: section, index: index, animation: animation).done {
                    if index == dataSections.count - 1 {
                        seal(())
                    }
                }
            }
        }
    }
    
    @discardableResult
    open func update(data: [[DataModel]], animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            for (index, section) in data.enumerated() {
                let dataSection = SFDataSection<DataModel>(content: section, identifier: "")
                update(dataSection: dataSection, index: index, animation: animation).done {
                    if index == data.count - 1 {
                        seal(())
                    }
                }
            }
        }
    }
    
    @discardableResult
    open func update(dataSection: SFDataSection<DataModel>, index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        if self.data.count > index {
            return Guarantee { seal in
                let olddataSection = self.data[index]
                let changes = diff(old: olddataSection.content, new: dataSection.content)
                self.data[index] = dataSection
                self.tableView?.reload(changes: changes, section: index, insertionAnimation: animation, deletionAnimation: animation, replacementAnimation: animation, completion: { (_) in
                    seal(())
                })
            }
        } else {
            return insert(section: dataSection, index: index)
        }
    }
    
    // MARK: - Sections
    
    @discardableResult
    open func insert(section: SFDataSection<DataModel>, index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data.append(section)
            self.tableView?.beginUpdates()
            self.tableView?.insertSections(IndexSet(integer: index), with: animation)
            self.tableView?.endUpdates()
            seal(())
        }
    }
    
    @discardableResult
    open func moveSection(from: Int, to: Int) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data.move(from: from, to: to)
            self.tableView?.moveSection(from, toSection: to)
            seal(())
        }
    }
    
    @discardableResult
    open func deleteSection(index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data.remove(at: index)
            self.tableView?.beginUpdates()
            self.tableView?.deleteSections(IndexSet(integer: index), with: animation)
            self.tableView?.endUpdates()
            seal(())
        }
    }
    
    @discardableResult
    open func reloadSection(index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.beginUpdates()
            self.tableView?.reloadSections(IndexSet(integer: index), with: animation)
            self.tableView?.endUpdates()
            seal(())
        }
    }
    
    // MARK: - Items
    
    open func getItem(at indexPath: IndexPath) -> DataModel {
        return data[indexPath.section].content[indexPath.row]
    }
    
    @discardableResult
    open func insert(item: DataModel, indexPath: IndexPath? = nil, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            let indexPath = indexPath ?? self.lastIndex
            if indexPath.section > self.lastSectionIndex {
                self.data.insert(SFDataSection<DataModel>(), at: self.lastSectionIndex)
            }
            self.data[indexPath.section].content.insert(item, at: indexPath.row)
            
            if self.tableView?.numberOfRows(inSection: indexPath.section) != self.data[indexPath.section].content.count {
                self.tableView?.beginUpdates()
                self.tableView?.insertRows(at: [indexPath], with: animation)
                self.tableView?.endUpdates()
                seal(())
            }
        }
    }
    
    @discardableResult
    open func moveItem(from: IndexPath, to: IndexPath) -> Guarantee<Void> {
        return Guarantee { seal in
            let item = self.data[from.section].content[from.item] // Get item to move
            self.data[from.section].content.remove(at: from.item) // Remove it from old indexPath
            self.data[to.section].content.insert(item, at: to.item) // Insert it to new indexPath
            self.tableView?.beginUpdates()
            self.tableView?.moveRow(at: from, to: to)
            self.tableView?.endUpdates()
            seal(())
        }
    }
    
    @discardableResult
    open func removeItem(from indexPath: IndexPath, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.data[indexPath.section].content.remove(at: indexPath.item)
            self.tableView?.beginUpdates()
            self.tableView?.deleteRows(at: [indexPath], with: animation)
            self.tableView?.endUpdates()
            seal(())
        }
    }
    
    @discardableResult
    open func reloadItem(from indexPath: IndexPath, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
            self.tableView?.beginUpdates()
            self.tableView?.reloadRows(at: [indexPath], with: animation)
            self.tableView?.endUpdates()
            seal(())
        }
    }
    
    // MARK: - UITableViewDataSource
    
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
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerStyle == nil ? CGFloat.leastNonzeroMagnitude : HeaderType.height
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerStyle = headerStyle {
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderType.identifier) as? HeaderType else { return nil }
            headerStyle(view, data[section], section)
            view.updateColors()
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerStyle == nil ? CGFloat.leastNonzeroMagnitude : FooterType.height
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerStyle = footerStyle {
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
    
}






























