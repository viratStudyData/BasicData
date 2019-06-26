//
//  GoogleLoginManager.swift
//  BaseProject
//
//  Created by OSX on 07/03/18.
//  Copyright © 2018 CodeBrew. All rights reserved.
//

import GoogleSignIn
import Foundation
import UIKit
protocol GoogleManagerDelegate {
    func didLogin(_ user: GIDGoogleUser?);
    func didLogout();
    func didDisconnect();
}
extension GoogleManagerDelegate{

  func didLogout(){
    
  }
}

class GoogleLoginManager: NSObject,GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let sharedInstance = GoogleLoginManager()
    fileprivate var delegate: GoogleManagerDelegate?
    var loggedUser: GIDGoogleUser?
    
    
    class func handleURL(_ url: URL, sourceApplication: String, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //MARK: - Login
    /** Login With Google **/
    func login(_ delegate: GoogleManagerDelegate?) {
        
        self.delegate = delegate
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func tryLogout() {
        GIDSignIn.sharedInstance().disconnect()
    }
    // MARK: GIDSignInDelegate
    // The sign-in flow has finished and was successful if |error| is |nil|.
    open func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations on signed in user here.
        if error != nil {
            if let safeValue = user, (self.delegate != nil) {
                self.delegate?.didLogin(safeValue)
            }else{
              delegate?.didDisconnect()
          }
        }
        else {
            print(user)
            print("name=\(String(describing: user.profile.name))")
            print("accessToken=\(String(describing: user.authentication.accessToken))")
            if GIDSignIn.sharedInstance().currentUser.authentication == nil {
                if (self.delegate != nil) {
                    self.delegate?.didLogout()
                }
            } else {
                if (self.delegate != nil) {
                    self.delegate?.didLogin(user)
                }
            }
        }
    }
    
    // This callback is triggered after the disconnect call that revokes data
    // access to the user's resources has completed.
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    open func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        // Perform any operations when the user disconnects from app here.
        print("didDisconnectWithUser")
        if (self.delegate != nil) {
            self.delegate?.didDisconnect()
        }
    }
    
    // MARK: GIDSignInUIDelegate
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    // The sign-in flow has finished selecting how to proceed, and the UI should no longer display
    // a spinner or other "please wait" element.
    open func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    // If implemented, this method will be invoked when sign in needs to display a view controller.
    // The view controller should be displayed modally (via UIViewController's |presentViewController|
    // method, and not pushed unto a navigation controller's stack.
    open func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        let vc: UIViewController = (self.delegate as? UIViewController) ?? UIViewController()
        vc.present(viewController ?? UIViewController(), animated: true, completion: nil)
    }
    
    // If implemented, this method will be invoked when sign in needs to dismiss a view controller.
    // Typically, this should be implemented by calling |dismissViewController| on the passed
    // view controller.
    open func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        guard let vc: UIViewController = (self.delegate as? UIViewController) else { return }
        vc.dismiss(animated: true, completion: {
            
        })
    }
    
    
}
