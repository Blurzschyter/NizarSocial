//
//  FeedVC.swift
//  NizarSocial
//
//  Created by NM on 15/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import UIKit

import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("JESS : ID REMOVED FROM KEYCHAIN - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }

}
