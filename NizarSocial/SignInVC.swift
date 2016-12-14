//
//  ViewController.swift
//  NizarSocial
//
//  Created by NM on 09/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func fbLoginPressed(_ sender: AnyObject) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            
//            if err != nil {
//                print("Custom FB login failed.")
//                return
//            } else {
//                print("SUCCESS LOGIN")
//            }
//            
//            print(result?.token.tokenString)
            
            if err != nil {
                print("NIZAR : Unable to authenticate with facebook - \(err)")
            } else if result?.isCancelled == true {
                print("NIZAR : User cancelled facebook authentication")
            } else {
                print("NIZAR : SUCCESSFULLY authenticate.")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
            
        }
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("NIZAR : Unable to authenticate with firebase - \(error)")
            } else {
                print("NIZAR : SUCCESS firebase authentication.")
            }
        })
    }
    
    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Did logout facebook.")
//    }
    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        
//        if error != nil {
//            print(error)
//            return
//        }
//        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (connection, result, err) in
//            
//            if err != nil {
//                print("Failed to start graph request: ", err)
//                return
//            } else {
//                print("SUCCESS START GRAPH REQUEST")
//            }
//            
//            print(result)
//        }
//    }
}

