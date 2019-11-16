//
//  SegmentViewDataSource.swift
//  WithInEarthUser
//
//  Created by Sierra 4 on 23/08/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//


import UIKit
import Foundation
import SJSegmentedScrollView

typealias SelectedSegmentIndex = (_ index: Int) -> ()
typealias MovedToSegment = (_ controller: UIViewController,_ segment: SJSegmentTab?,_ index: Int) -> ()


class SegmentViewDataSource: NSObject {
    
    var segments: Array<UIViewController>?
    var containerView: UIView?
    var segmentController:SJSegmentedViewController?
    var segmentViewHeight: CGFloat = 48
    var segmentTitleFont:UIFont = UIFont.systemFont(ofSize: 14)
    var segmentTitleColor:UIColor = UIColor.black
    var selectedSegmentTitleFont:UIFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 2))
    var selectedSegmentTitleColor:UIColor = UIColor.black
    var selectedSegmentBackgroundColor = UIColor.lightGray
    var selectedSegmentBarHeight:CGFloat = 2
    var segmentShadow = SJShadow.light()
    var selectedIndex:SelectedSegmentIndex?
    var movedToSegment:MovedToSegment?
    
    
    init(segmentController: SJSegmentedViewController?, containerView: UIView?, segments: Array<UIViewController>?, segmentViewHeight: CGFloat, segmentTitleFont: UIFont, segmentTitleColor: UIColor, selectedSegmentTitleFont: UIFont, selectedSegmentBackgroundColor: UIColor, selectedSegmentTitleColor: UIColor, selectedSegmentBarHeight: CGFloat, segmentShadow: SJShadow, selectedIndex: @escaping SelectedSegmentIndex, movedToSegment: @escaping MovedToSegment) {
        
        self.segmentController = segmentController
        self.containerView = containerView
        self.segments = segments
        self.segmentViewHeight = segmentViewHeight
        self.segmentTitleFont = segmentTitleFont
        self.segmentTitleColor = segmentTitleColor
        self.selectedSegmentTitleFont = selectedSegmentTitleFont
        self.selectedSegmentTitleColor = selectedSegmentTitleColor
        self.selectedSegmentBackgroundColor = selectedSegmentBackgroundColor
        self.selectedSegmentBarHeight = selectedSegmentBarHeight
        self.selectedIndex = selectedIndex
        self.movedToSegment = movedToSegment
        
        if let segmentHome = self.segmentController, let container = self.containerView, let childVCs = self.segments {
            segmentHome.segmentControllers = childVCs
            segmentHome.segmentViewHeight = self.segmentViewHeight
            segmentHome.segmentTitleFont = segmentTitleFont
            segmentHome.segmentTitleColor = self.segmentTitleColor
            segmentHome.headerViewHeight = 56.0
            segmentHome.headerViewOffsetHeight = 31.0
            segmentHome.selectedSegmentViewColor = UIColor.black
            segmentHome.selectedSegmentViewHeight = 2
            segmentHome.segmentShadow = segmentShadow//SJShadow.light()
            container.addSubview(segmentHome.view)
            segmentHome.view.frame = (container.bounds)
        }
    }
    
    
    func widthWithConstrainedWidth(_ title: String, _ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = title.boundingRect(with: constraintRect,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
}


extension SegmentViewDataSource: SJSegmentedViewControllerDelegate {
    
    func didSelectSegmentAtIndex(_ index: Int) {
        print(index)
        if let block = selectedIndex {
            block(index)
        }
    }
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if segment != nil {
            segment?.titleColor(self.segmentTitleColor)
            segment?.titleFont(self.selectedSegmentTitleFont)
        }
        
        if let count = segmentController?.segments.count {
            if count > 0 {
                
                segment?.titleColor(self.segmentTitleColor)
                segment?.titleFont(self.selectedSegmentTitleFont)
            }
        }
        
        if let block = self.movedToSegment {
            block(controller, segment, index)
        }
        
    }
    
}


