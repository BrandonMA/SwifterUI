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

public struct SFTableSection<DataModel: Hashable> {
    
    public var content: [DataModel]
    public var identifier: String
    
    public init(content: [DataModel] = [], identifier: String = "") {
        self.content = content
        self.identifier = identifier
    }
}

open class SFTableManager<DataModel: Hashable, CellType: SFTableViewCell>: NSObject, UITableViewDataSource {
    
    // MARK: - Instance Properties
    
    private var data: [SFTableSection<DataModel>] = [SFTableSection<DataModel>()]
    public weak var tableView: SFTableView?
    
    public var lastSectionIndex: Int {
        return data.count == 0 ? data.count : data.count - 1
    }
    
    public var lastIndex: IndexPath {
        return data[lastSectionIndex].content.count == 0 ? IndexPath(row: 0, section: lastSectionIndex) : IndexPath(row: data[lastSectionIndex].content.count, section: lastSectionIndex)
    }
    
    open var cellHandler: ((CellType, DataModel, IndexPath) -> ())? = nil
    
    // MARK: - Initializers
    
    public init(dataSections: [SFTableSection<DataModel>] = []) {
        super.init()
        update(dataSections: dataSections)
    }
    
    public init(data: [[DataModel]] = []) {
        super.init()
        update(data: data)
    }
    
    // MARK: - Instace Methods
    
    open func configure(tableView: SFTableView) {
        self.tableView = tableView
        tableView.dataSource = self
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.identifier)
        tableView.rowHeight = CellType.height
    }
    
    open func update(dataSections: [SFTableSection<DataModel>], animation: UITableViewRowAnimation = .fade) {
        for (index, section) in dataSections.enumerated() {
            DispatchQueue.addAsyncTask(to: .main) {
                self.update(tableSection: section, index: index, animation: animation)
            }
        }
    }
    
    open func update(data: [[DataModel]], animation: UITableViewRowAnimation = .fade) {
        for (index, section) in data.enumerated() {
            DispatchQueue.addAsyncTask(to: .main) {
                let tableSection = SFTableSection<DataModel>(content: section, identifier: "")
                self.update(tableSection: tableSection, index: index, animation: animation)
            }
        }
    }
    
    private func update(tableSection: SFTableSection<DataModel>, index: Int, animation: UITableViewRowAnimation = .fade) {
        if self.data.count > index {
            let oldTableSection = self.data[index]
            let changes = diff(old: oldTableSection.content, new: tableSection.content)
            self.data[index] = tableSection
            self.tableView?.reload(changes: changes, section: index, insertionAnimation: animation, deletionAnimation: animation, replacementAnimation: animation, completion: { (_) in
            })
        } else {
            insert(section: tableSection, index: index)
        }
    }
    
    // MARK: - Sections
    
    @discardableResult
    open func insert(section: SFTableSection<DataModel>, index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
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
    
    // TODO: incomplete
    @discardableResult
    open func deleteSection(index: Int, animation: UITableViewRowAnimation = .fade) -> Guarantee<Void> {
        return Guarantee { seal in
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
                self.data.insert(SFTableSection<DataModel>(), at: self.lastSectionIndex)
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
            self.data[indexPath.section].content.remove(at: indexPath.item)
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
        cellHandler?(cell, data[indexPath.section].content[indexPath.row], indexPath)
        return cell
    }
}
