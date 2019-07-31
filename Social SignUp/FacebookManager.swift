//
//  FacebookManager.swift
//  ProSwingsUser
//
//  Created by cblmacmini on 4/27/16.
//  Copyright © 2016 Gagan. All rights reserved.

import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

typealias FacebookCallback = (_ facebook: Facebook) -> ()
typealias FacebookCallbackError = (_ error: String) -> ()

enum ParamKeys: String {
    case fbFirstName = "first_name"
    case fbLastName = "last_name"
    case emailId = "email"
    case phone = "phone"
    
    case deviceType = "IOS"
}

class FacebookManager: NSObject {
    
    weak var viewController: UIViewController?
    let permissions = ["public_profile","email"]
    
    var facebookCallback: FacebookCallback?
    var facebookCallbackError: FacebookCallbackError?
    
    static let shared = FacebookManager()
    
    override init() {
        super.init()
    }
    
    
    func configureLoginManager(sender: UIViewController, success: @escaping FacebookCallback , failure: @escaping FacebookCallbackError ){
        facebookCallbackError = failure
        facebookCallback = success
        
        viewController = sender
        
        let loginManager = FBSDKLoginManager()
        
        loginManager.logOut()
        
        loginManager.logIn(withReadPermissions: permissions, from: viewController, handler: {
            [weak self] (result, error) in
            
            if let err = error {
                failure(err.localizedDescription)
                print(err.localizedDescription)
            } else if (result?.isCancelled)! {
                failure("Cancelled")
                print("Cancelled")
            } else {
                self?.sendGraphRequest()
            }
        })
        
    }
    
    func sendGraphRequest() {
       
        let connection = GraphRequestConnection()
        var request = GraphRequest.init(graphPath: "me")
        request.parameters = ["fields":"first_name,last_name,picture.type(large),email"]
        
        connection.add(request, completion: {
            (response1, result) in
            print("Facebook graph Result:", result)
            switch result {
            case .success(let response):
                if let block = self.facebookCallback, let data = response.dictionaryValue {
                    
                    let fbProfile = Facebook(result: data)
                    block(fbProfile)
                }
                
            case .failed(let error):
                if let errorBlock = self.facebookCallbackError{
                    errorBlock(error.localizedDescription)
                }
                print(error.localizedDescription)
            }
            
        })
        connection.start()
    }
    
}


class Facebook: NSObject {
    
    var fbId: String?
    var firstName: String?
    var lastName: String?
    var imageUrl: String?
    var email: String?
    var phone:String?
    
    
    init(result: Any?) {
        super.init()
      
        guard let result = result as? [String: Any] else { return }
        print(result)
        fbId = FBSDKAccessToken.current().userID
        firstName = /(result[ParamKeys.fbFirstName.rawValue] as? String)
        lastName =  /(result[ParamKeys.fbLastName.rawValue] as? String)
        phone = /(result[ParamKeys.phone.rawValue] as? String)
        let width = Int(UIScreen.main.bounds.size.width)
        imageUrl = "https://graph.facebook.com/".appending(/fbId).appending("/picture??width=" + "\(width)" + "&height=362")
        email = /(result[ParamKeys.emailId.rawValue] as? String)
        
    }
    
    override init() {
        super.init()
    }
}
