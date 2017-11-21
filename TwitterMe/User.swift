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
    var followersCount: Int?
    var followingCount: Int?
    var dictionary: NSDictionary?
    
    
     var _profilePicture: UIImage? // This helps keep track to see if image was previously loaded...
    
    var profilePicture: UIImage? {
        get{
            if (_profilePicture == nil){
                //Load picture from API
                return nil // Stub
            }else {
                return _profilePicture
            }
         
        }
        
        set(image){
            self._profilePicture = image
        
        }
    
    }
    
    init(dictionary: NSDictionary){
        
        
        //Deserialization code
        self.name = dictionary["name"] as? String
        
        self.dictionary = dictionary
        
        self.screenname = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
           
            self.profileUrl = URL(string: profileUrlString)
        }
                
        
        self.tagline = dictionary["description"] as? String
        
        self.followersCount = dictionary["followers_count"] as? Int
        self.followingCount = dictionary["friends_count"] as? Int
        
        
    }
    
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get {
            if (_currentUser == nil){
                let defaults = UserDefaults.standard
                
                let jsonUserData =  defaults.object(forKey: "currentUser") as? Data
                
                if let jsonUserData = jsonUserData{
                    let dictionary = try! JSONSerialization.jsonObject(with: jsonUserData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
                
            }
           
            
           
            
            return _currentUser
        }
        
        set(user){
            let defaults = UserDefaults.standard
            _currentUser = user
            
            if let user = user {
                
                let userDictionary = user.dictionary!
                let valid = JSONSerialization.isValidJSONObject(userDictionary)
                
                print("Is valid JSON: \(valid)")
                let jsonData  = try! JSONSerialization.data(withJSONObject: userDictionary, options: [])
                
                defaults.set(jsonData, forKey: "currentUser")
            }else {
                defaults.set(nil, forKey:"currentUser")
            }
            
            
            defaults.synchronize()
        }
    }

}
