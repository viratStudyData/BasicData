//
//  LoginVC.swift
//  Wasaf
//
//  Created by OSX on 16/07/18.
//  Copyright © 2018 Sandeep. All rights reserved.
//

import UIKit
import Auth0

class LoginVC: UIViewController
{
    //MARK:- ======== Variables ========
    var linkedinLoginManager = LinkedinLoginManager()

    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- ======== Actions ========
    @IBAction func btnClickedLogin(_ sender:UIButton) {
        self.view.endEditing(true)
        linkedInLogin()
    }
}

//MARK:- ======== Api ========
extension LoginVC
{
    func login(objUser:Profile) {
        let objR = LoginEndpoint.linkedInLogin(
            name: /objUser.name
            , email: /objUser.email
            , phoneNumber: ""
            , originalUrl: /objUser.pictureURL.absoluteString
            , thumbnailUrl: /objUser.pictureURL.absoluteString)
        
        objR.request(isLoaderNeeded: true) {
            
            [weak self] (responce) in
            guard let self = self else { return }
            
            switch responce {
            case .success(let data):
                guard let obj = data as? ApiSucessData<UserData> else { return }
                guard let model = obj.object else {
                    self.alertBoxOk(message: "Try Again", title: /obj.message, ok: {
                        
                    })
                    return
                }

                UDSingleton.shared.userData = model
                guard let appD = UIApplication.shared.delegate as? AppDelegate else { return }
                appD.setRootTabBar()
                
            default:
                break
            }
        }
    }
}

//MARK:- ======== LinkedIn ========
extension LoginVC
{
  
  func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
      let path = bundle.path(forResource: "Auth0", ofType: "plist"),
      let values = NSDictionary(contentsOfFile: path) as? [String: Any]
      else {
        print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
        return nil
    }
    
    guard
      let clientId = values["ClientId"] as? String,
      let domain = values["Domain"] as? String
      else {
        print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
        print("File currently has the following entries: \(values)")
        return nil
    }
    return (clientId: clientId, domain: domain)
  }

  
  func getUserInfoFromAuth0(token: String) {
    Auth0
    .authentication()
    .userInfo(token: token)
      .start { (result) in
        
        switch result {
        case .success(let profile):
          let obj = profile
          self.login(objUser: obj)
          print("Profile: \(profile.email, profile.id, profile.name, profile.pictureURL, profile.userMetadata)")

        case .failure(let error):
          Toast.show(text: error.localizedDescription, type: .error)
        }
        
        
    }
  }
  
  
    func linkedInLogin() {
      
      guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
      Auth0
        .webAuth()
        .scope("openid profile email")
        .audience("https://" + clientInfo.domain + "/userinfo")
        .start {
          switch $0 {
          case .failure(let error):
            Toast.show(text: error.localizedDescription, type: .error)
          case .success(let credentials):
            guard let accessToken = credentials.accessToken else { return }
            self.getUserInfoFromAuth0(token: accessToken)
            
          }
      }
      

    }
}
