//
//  PostCell.swift
//  NizarSocial
//
//  Created by NM on 17/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeImg: CircleView!
    
    
    var post: Post! //post is using Type Post
    
   
    var likesref: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //ui tap recognizer(drag n drop) cant be used at LIKES btn since it will generated repeatative list. therefore, we will manually program it.
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1 //just tapped/pressed on times only to activate the next action
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }

    func configureCell(post: Post, img: UIImage? = nil) { //the image is optional.maybe available, maybe not. if the image is not available, it will set to nil by default
        
        self.post = post
        
         likesref = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        if img != nil { //this means image is in available in local cache
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JESS : Unable to download image from Firebase storage")
                } else {
                    print("JESS : Successfully download image from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
        //--TO SEE EITHER THE CURRENT USER ALREADY LIKE THE IMAGE OR NOT--
        //let likesref = DataService.ds.REF_USER_CURRENT.child("likes")
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        //let likesref = DataService.ds.REF_USER_CURRENT.child("likes")
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart") //adjust the current heart image
                self.post.adjustLikes(addLike: true) //adjust the likes number
                self.likesref.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
        
    }

}
