//
//  DataServices.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-28.
//  Copyright © 2016 Bagga. All rights reserved.
//

import Foundation
import Firebase

class DataServices{
    static let ds = DataServices()
    
    private var _REF_BASE = Firebase(url: "https://pokeyou.firebaseio.com/")
    
    var REF_BASE:Firebase{
        return _REF_BASE
    }
    
    
}
