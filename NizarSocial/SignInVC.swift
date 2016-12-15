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
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func fbLoginPressed(_ sender: AnyObject) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            
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
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil { //user registered in the system.
                    print("NIZAR : CURRENT USER SUSCESSFULLY AUTHENTICATE WITH FIREBASE.")
                } else { //user not registered. auto registered.
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("NIZAR : Unable to authenticate new user using Firebase's Email")
                        } else {
                            print("NIZAR : Successfully authenticate & create user using Firebase's email")
                        }
                    })
                }
                
            })
            
        }
        
    }
    
    
}
