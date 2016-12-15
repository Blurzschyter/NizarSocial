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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //segue need to be performed inside viewdidappear. cant be cone in viewdidload
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    @IBAction func fbLoginPressed(_ sender: AnyObject) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            
            if err != nil {
                print("JESS : Unable to authenticate with facebook - \(err)")
            } else if result?.isCancelled == true {
                print("JESS : User cancelled facebook authentication")
            } else {
                print("JESS : SUCCESSFULLY authenticate.")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
            
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("JESS : Unable to authenticate with firebase - \(error)")
            } else {
                print("JESS : SUCCESS firebase authentication.")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil { //user registered in the system.
                    print("JESS : CURRENT USER SUSCESSFULLY AUTHENTICATE WITH FIREBASE.")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else { //user not registered. auto registered.
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS : Unable to authenticate new user using Firebase's Email")
                        } else {
                            print("JESS : Successfully authenticate & create user using Firebase's email")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JESS : Data saved to the keychain - \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
}
