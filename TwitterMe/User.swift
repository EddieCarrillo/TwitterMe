//
//  User.swift
//  TwitterMe
//
//  Created by my mac on 11/1/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

//Models used also for persistence

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    
    init(dictionary: NSDictionary){
        
        //Deserialization code
        self.name = dictionary["name"] as? String
        
        self.screenname = dictionary["screen_name"] as? String
        
        if   let profileUrlString = dictionary["profile_image_url_https"] as? String {
            self.profileUrl = URL(string: profileUrlString)
        }
        
        
        self.tagline = dictionary["description"] as? String
        
    }

}
