//
//  Post.swift
//  NizarSocial
//
//  Created by NM on 18/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String! //post ID actually
    private var _postRef: FIRDatabaseReference!
    
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageURL:String, likes:Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POST.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike { //true
            _likes = _likes + 1
        } else { //false
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }
    
}
