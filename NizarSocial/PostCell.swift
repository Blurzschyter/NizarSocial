//
//  PostCell.swift
//  NizarSocial
//
//  Created by NM on 17/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import UIKit

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

    func configureCell(post: Post) {
        
        self.post = post
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
    }

}
