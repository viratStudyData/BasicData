//
//  CollectionViewDataSource.swift
//  SafeCity
//
//  Created by Aseem 13 on 29/10/15.
//  Copyright © 2015 Taran. All rights reserved.
//


import UIKit


typealias ScrollViewScrolled = (UIScrollView) -> ()
typealias WillDisplay = (_ indexPath: IndexPath) -> ()
typealias SizeBlock = (_ indexPath: IndexPath) -> CGSize
class CollectionViewDataSource: NSObject
{
    var collectionView              : UICollectionView?
    
    var items                       : [Any] = []
    var cellHeight                  : CGFloat = 0.0
    var cellWidth                   : CGFloat = 0.0
    
    var cellIdentifier              : String?
    var headerIdentifier            : String?
    
    var scrollViewListener          : ScrollViewScrolled?
    var configureCellBlock          : ListCellConfigureBlock?
    var aRowSelectedListener        : DidSelectedRow?
    var willDisplay                 : WillDisplay?
    
    var blockCellIdentifier         : BlockCellIdentifier?
    var sizeBlock: SizeBlock?
    init (items: [Any],
          collectionView: UICollectionView?,
          cellIdentifier: String? = nil,
          headerIdentifier: String? = nil,
          cellHeight: CGFloat = 0.0,
          cellWidth: CGFloat = 0.0) {
        
        self.collectionView = collectionView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        self.cellWidth  = cellWidth
        self.cellHeight = cellHeight
        
    }
    
    override init() {
        super.init()
    }
    
    //MARK:- ======== Functions ========
    func reload(items: [Any]?) {
        
        self.items = items ?? []
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.reloadData()
    }
}

extension CollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.row]
        
        var identifierCell:String? = self.blockCellIdentifier?(indexPath)
        
        if identifierCell == nil {
            identifierCell = cellIdentifier
        }
        
        guard let identifier = identifierCell else {
            fatalError("Cell identifier not provided")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as UICollectionViewCell
        
        if let block = self.configureCellBlock {
            block(cell, item, indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = self.items[indexPath.row]
        
        if let block = self.aRowSelectedListener {
            block(indexPath, item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let block = willDisplay {
            block(indexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let block = self.scrollViewListener {
            block(scrollView)
        }
    }
}

extension CollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return (self.sizeBlock?(indexPath)) ?? CGSize(width: cellWidth, height: cellHeight)
    }
}
