//
//  DataService.swift
//  NizarSocial
//
//  Created by NM on 17/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference() //contain the url of the database from firebase console.
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService() // this create the singleton. which means, it globally accessable.
    
    //db references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POST: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
}
