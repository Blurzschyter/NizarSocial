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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController() //initialize imagepicker
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POST.observe(.value, with: { (snapshot) in
            
            self.posts = [] //to solve duplicate view post bug
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP : \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    //numberofsection
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //numberofrowsinsection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //cellforrow indexpath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let post = posts[indexPath.row]
        //print("JESS : \(post.caption)")
        
        //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
        } else {
            return PostCell()
        }
        
    }
    
    //didfinishpickingmediawithinfo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //when user select an image from the storage, get rid of the imagepicker view.
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("JESS : A valid image wasn't selected.")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImagePressed(_ sender: AnyObject) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func signOutPressed(_ sender: AnyObject) {
        
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("JESS : ID REMOVED FROM KEYCHAIN - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }

}
