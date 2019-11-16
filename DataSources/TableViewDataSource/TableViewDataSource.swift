//
//  TableViewDataSource.swift
//  SafeCity
//
//  Created by Aseem 13 on 29/09/15.
//  Copyright (c) 2015 Taran. All rights reserved.
//


import UIKit

typealias ListCellConfigureBlock = (_ cell: Any, _ item: Any?, _ indexpath: IndexPath) -> ()
typealias DidSelectedRow = (_ indexPath: IndexPath, _ cell: Any) -> ()
typealias WillDisplayCell = (_ indexPath: IndexPath, _ cell: UITableViewCell) -> ()
typealias ScrollViewScroll = (_ scrollView: UIScrollView) -> ()
typealias DeleteAction  = (_ indexPath: IndexPath) -> ()
typealias CanRowEdit = (_ indexPath: IndexPath) -> (Bool)
typealias BlockCellIdentifier = (_ indexPath: IndexPath) -> String?
typealias HeightForRowAt = (_ indexPath: IndexPath)-> (CGFloat)

class TableViewDataSource: NSObject {
    
    var tableView : UITableView?
    
    var items: [Any]?
    var cellIdentifier: String?
    
    var configureCellBlock: ListCellConfigureBlock?
    var aRowSelectedListener: DidSelectedRow?
    var scrollViewScroll:  ScrollViewScroll?
    var willDisplayCell: WillDisplayCell?
    
    var blockCellIdentifier: BlockCellIdentifier?
    var heightForRowAt: HeightForRowAt?
    var deleteAction: DeleteAction?
    var canRowEdit: CanRowEdit?
    
    //    var direction: DirectionForScroll?
    
    var cellHeight: CGFloat = UITableView.automaticDimension
    
    init (items: [Any]?, tableView: UITableView?, cellIdentifier: String?, cellHeight:CGFloat = UITableView.automaticDimension) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        
        self.tableView = tableView
        self.cellHeight = cellHeight
    }

    override init() {
        super.init()
    }
    
    //MARK:- ======== Functions ========
    func reloadTable(items: [Any]?) {
        
        self.items = items
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
}

extension TableViewDataSource: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.items?[indexPath.row]
        
        var identifierCell = self.blockCellIdentifier?(indexPath)
        
        if identifierCell == nil {
            identifierCell = cellIdentifier
        }
        
        guard let identifier = identifierCell else {
            fatalError("Cell identifier not provided")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError("Cell not provided")
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureCellBlock {
            block(cell, item, indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener,
            case let cell as Any = tableView.cellForRow(at: indexPath) {
            block(indexPath , cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.items?.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.heightForRowAt?(indexPath)) ?? cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let block = willDisplayCell {
            block(indexPath, cell)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = scrollViewScroll {
            block(scrollView)
        }
    }
}

class TableViewChefDishesDataSource : TableViewDataSource {
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: TitleType.delete.rawValue) { action, index in
            if let block = self.deleteAction {
                block(editActionsForRowAt)
            }
            
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if let block = self.canRowEdit {
            return block(indexPath)
        }
        return true
        
    }
}
