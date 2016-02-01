//
//  Post.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-29.
//  Copyright © 2016 Bagga. All rights reserved.
//

import Foundation
import Firebase

class Post{
    private var _postDescription:String!
    private var _imageUrl:String?
    private var _likes:Int!
    private var _username:String!
    private var _postKey:String!
    private var _postRef:Firebase!
    
    var postDesc:String{
     return _postDescription
    }
    var imageUrl:String?{
        return _imageUrl
        
    }
    var likes:Int{
        return _likes
    }
    var username:String{
        return _username
    }
    var postKey:String{
        return _postKey
    }
    init(description:String,imageUrl:String?,username:String){
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    init(postKey:String, dictionary:Dictionary<String,AnyObject>){
        self._postKey = postKey
        if let imgUrl = dictionary["imageUrl"] as? String{
           self._imageUrl = imgUrl
        }
        if let likes = dictionary["likes"] as? Int{
            self._likes = likes
        }
        if let desc = dictionary["description"] as? String{
            self._postDescription = desc
        }
        self._postRef = DataServices.ds.REF_POSTS.childByAppendingPath(self._postKey)
    }
    func adjustLikes(addLikes:Bool){
        if addLikes{
            _likes = _likes + 1
        }
        else{
            _likes = _likes - 1
        }
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
    
}
