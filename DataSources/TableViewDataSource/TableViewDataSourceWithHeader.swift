//
//  TableViewDataSourceWithHeader.swift
//  Auttle
//
//  Created by CodeBrew on 8/30/17.
//  Copyright © 2017 CodeBrew. All rights reserved.
//

import UIKit

typealias HeightFoHeaderInSection = (_ section: Int, _ sectionObj:TableViewHeaderObjectType) -> CGFloat?
typealias ViewForHeaderInSection = (_ section: Int, _ sectionObj:TableViewHeaderObjectType) -> UIView?

//MARK:- ======== TableViewHeaderObjectType ========
struct TableViewHeaderObjectType {
    
    var header:String = ""
    var footer:String = ""
    var type:Any?
    var rows:[Any] = []
    
    init(header: String = "", footer: String = "", rows: [Any], type: Any?) {
        self.header = header
        self.footer = footer
        self.rows = rows
        self.type = type
    }
}

//MARK:- ======== TableViewDataSourceWithHeader ========
class TableViewDataSourceWithHeader: TableViewDataSource {
    
    var viewforHeaderInSection: ViewForHeaderInSection?
    var viewForFooterInSection: ViewForHeaderInSection?
    
    var headerHeight: CGFloat = 0.0
    var footerHeight: CGFloat = 0.0
    
    var heightForHeaderInSection:HeightFoHeaderInSection?
    var heightForFooterInSection:HeightFoHeaderInSection?

    override init() {
        super.init()
    }
    
    required init(items: [Any],
                  tableView: UITableView?,
                  cellIdentifier: String?,
                  cellHeight: CGFloat = UITableView.automaticDimension,
                  headerHeight:CGFloat = 0,
                  footerHeight:CGFloat = 0) {
        
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        
        super.init(items: items, tableView: tableView, cellIdentifier: cellIdentifier, cellHeight: cellHeight)
    }

    ///Indexing
    override func numberOfSections(in tableView: UITableView) -> Int {
        return /items?.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemSection = self.items?[section] as? TableViewHeaderObjectType {
            return itemSection.rows.count
        }
        return 0
    }
    
    ///cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifierCell = self.blockCellIdentifier?(indexPath)
        
        if identifierCell == nil {
            identifierCell = cellIdentifier
        }
        
        guard let identifier = identifierCell else {
            fatalError("Cell identifier not provided")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError("Cell is not register")
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let block = self.configureCellBlock,
            let itemSection = self.items?[indexPath.section] as? TableViewHeaderObjectType {
            let item = itemSection.rows[indexPath.row]
            block(cell, item, indexPath)
        }
        return cell
    }
    
    ///viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let viewH = viewforHeaderInSection?(section, itemSection) else { return nil }
        return viewH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let height = heightForHeaderInSection?(section, itemSection) else { return headerHeight }
        return height
    }
    
    ///viewForFooterInSection
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
            let viewH = viewForFooterInSection?(section, itemSection) else { return nil }
        return viewH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let itemSection = self.items?[section] as? TableViewHeaderObjectType,
        let height = heightForFooterInSection?(section, itemSection) else { return footerHeight }
        return height
    }
}
