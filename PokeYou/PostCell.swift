//
//  PostCell.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-28.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage :UIImageView!
    @IBOutlet weak var showCase :UIImageView!
    @IBOutlet weak var descriptionText:UITextView!
    @IBOutlet weak var likesLabel:UILabel!
    var post :Post!
    var request : Request?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func drawRect(rect: CGRect) {
      profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        showCase.clipsToBounds = true
    }
    func configureCell(post:Post, img : UIImage?){
        self.post = post
        self.descriptionText.text = post.postDesc
        self.likesLabel.text = "\(post.likes)"
        
        if post.imageUrl != nil{                    //Checking for empty image
            if img != nil{
                self.showCase.image = img
            }
            else{
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request , response, data , err in
                    print(request)
                    print(response)
                    print(err)
                    
                    
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
    }
    

}
