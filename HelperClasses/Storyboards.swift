//
//  Storyboard.swift
//  CancerCoaches
//
//  Created by Apple on 13/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func getVC(_ storyBoard: Stortyboard) -> Self {
        
        func instanceFromNib<T: UIViewController>(_ storyBoard: Stortyboard) -> T {
            guard let vc = controller(storyBoard: storyBoard.rawValue, controller: T.identifier) as? T else {
                fatalError("Not ViewController")
            }
            
            return vc
        }
        
        return instanceFromNib(storyBoard)
    }
    
    static func controller(storyBoard: String, controller: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyBoard, bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: controller)
        return vc
    }
}

enum Stortyboard: String {
    case login = "Login"
    case home = "Home"
}
