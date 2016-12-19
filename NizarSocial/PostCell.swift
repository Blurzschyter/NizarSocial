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
    
    var post: Post! //post is using Type Post

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post, img: UIImage? = nil) { //the image is optional.maybe available, maybe not. if the image is not available, it will set to nil by default
        
        self.post = post
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
        
    }

}
