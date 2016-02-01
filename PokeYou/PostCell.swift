//
//  PostCell.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-28.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage :UIImageView!
    @IBOutlet weak var showCase :UIImageView!
    @IBOutlet weak var descriptionText:UITextView!
    @IBOutlet weak var likesLabel:UILabel!
    @IBOutlet weak var likesImage:UIImageView!
    var post :Post!
    var request : Request?
    var likesRef:Firebase!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.userInteractionEnabled = true
        
    }
    override func drawRect(rect: CGRect) {
      profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        showCase.clipsToBounds = true
    }
    func configureCell(post:Post, img : UIImage?){
        self.post = post
        likesRef = DataServices.ds.REF_USERS_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        self.descriptionText.text = post.postDesc
        self.likesLabel.text = "\(post.likes)"
        
        if post.imageUrl != nil{                    //Checking for empty image
            if img != nil{
                self.showCase.image = img
            }
            else{
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request , response, data , err in
                    //print(request)
                    print(response)
                   // print(data)
                    
                    
                    if err == nil{
                        let img = UIImage(data: data!)!         //Forcing unwrapping
                        self.showCase.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        }else{
           self.showCase.hidden = true
        }
       
        likesRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
        
            if let doesNotExist = snapshot.value as? NSNull{
                //user dont like any post
                self.likesImage.image = UIImage(named: "heart-empty")
                
            }else{
                self.likesImage.image = UIImage(named: "heart-full")
            }
        })
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.showCase.hidden = false
    }
    func likeTapped(sender:UITapGestureRecognizer){
        likesRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull{
                //user dont like any post
                self.likesImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likesRef.setValue(true)
                
            }else{
                self.likesImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likesRef.removeValue()
            }
        })

    }

}
