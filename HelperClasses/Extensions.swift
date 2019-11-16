//
//  Extensions.swift
//  CancerCoaches
//
//  Created by Apple on 10/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable

extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UITextField {
    
    @IBInspectable var leftPadding: Int {
        get { return 0 }
        set {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 20))
            leftView = paddingView
            leftViewMode = .always
            
        }
    }
}

extension UIColor {
    static var theme = #colorLiteral(red: 0.5098039216, green: 0.2549019608, blue: 0.6078431373, alpha: 1)
    
}

extension String {
    // Trims white space and new line characters, returns a new string
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func textSize(font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = self
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        return size
    }
}

extension UIButton {
    func toggle() -> Bool {
        isSelected = (isSelected) ? false : true
        return isSelected
        
    }
    
    @IBInspectable
    open var exclusiveTouchEnabled : Bool {
        get {
            return self.isExclusiveTouch
        }
        set(value) {
            self.isExclusiveTouch = value
        }
    }
}
