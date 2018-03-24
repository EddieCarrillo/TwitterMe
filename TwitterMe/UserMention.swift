//
//  UserMention.swift
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation


class UserMention {
   
    
    //ID of the mentioned user, as an integer
    var id: Int?
    let idKey: String = "id"
    
    var idStr: String?
    let idStrKey: String = "id_str"
    
    var indices: [Int]?
    let indicesKey: String = "indices"
    
    //Display name of the referenced user
    var name: String?
    let nameKey = "name"
    
    //Screen name of the referenced user
    //screen_name
    var screenName: String?
    let screenNameKey = "screen_name"
    
    
    
    init(dictionary: NSDictionary){
        if let id = dictionary[idKey] as? Int{
            self.id = id
        }
        if let idStr = dictionary[idStrKey] as? String{
            self.idStr = idStr
        }
        if let indices = dictionary[indicesKey] as? [Int]{
            self.indices = indices
        }
        if let name = dictionary[nameKey] as? String{
            self.name = name
        }
        if let screenName = dictionary[screenNameKey] as? String{
            self.screenName = screenName
        }
        
    }
    
    class func toMentionArray(dictionaries: [NSDictionary]) -> [UserMention]{
        var mentions: [UserMention] = []
        
        for dictionary in dictionaries{
            mentions.append(UserMention(dictionary: dictionary))
        }
        
        return mentions
    }
    


}
