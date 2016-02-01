//
//  DataServices.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-28.
//  Copyright © 2016 Bagga. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = Firebase(url: "https://pokeyou.firebaseio.com/")

class DataServices{
    static let ds = DataServices()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE:Firebase{
        return _REF_BASE
    }
    var REF_POSTS:Firebase{
        return _REF_POSTS
    }
    var REF_USERS:Firebase{
        return _REF_USERS
    }
    var REF_USERS_CURRENT:Firebase{
        let uid = NSUserDefaults.standardUserDefaults().valueForKeyPath(key) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    func createFireBaseUser(uid:String, user:Dictionary<String,String>){
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
    
}
