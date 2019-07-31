//
//  SocialLoginActions.swift
//  
//
//  Created by Apple on 03/07/19.
//

import UIKit

class SocialLoginActions: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnContinueWithFBAction(_ sender: Any) {
        FacebookManager.shared.configureLoginManager(sender: self, success: {
            [weak self] (fbData) in
            
            guard let self = self else { return }
            
            print(/fbData.firstName)
            //            self.objModel.loginType = SignInType.social.rawValue
            //            self.objModel.name = /fbData.firstName + " " + /fbData.lastName
            //            self.objModel.email = /fbData.email
            //            self.objModel.socialKey = /fbData.fbId
            //            self.objModel.profilePic = .init()
            //            self.objModel.profilePic?.original = /fbData.imageUrl
            //            self.objModel.phoneNo = (/fbData.phone == "" ) ? nil : /fbData.phone
            //
            //            self.verifyEmailAPI(email: /fbData.email, userObject: self.objModel)
            
            }, failure: { (error) in
                print(error)
        })
    }

}
