//
//  Hashtag.swift
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation


class Hashtag {
    //An array of integers indicating the offsets within the Tweet text where the hashtag begins and ends. The first integer represents the location of the # character in the Tweet text string. The second integer represents the location of the first character after the hashtag. Therefore the difference between the two numbers will be the length of the hashtag name plus one (for the ‘#’ character). Example: "indices":[32,38]
    var indices: [Int]?
    let indicesKey = "indices"
    
    
    //Name of the hashtag, minus the leading ‘#’ character. Example:
    var text: String?
    let textKey = "text"
    
    
    init(dictionary: NSDictionary){
        if let indices = dictionary[indicesKey] as? [Int]{
            self.indices = indices
        }
        
        if let text = dictionary[textKey] as? String {
            self.text = text
        }
        
        
        
    }
    
    
    class func toHashTagArray(hashtagDictionaries: [NSDictionary]) -> [Hashtag]{
        
        var hashtags: [Hashtag] = []
        
        for hashTagDictionary in hashtagDictionaries{
            hashtags.append(Hashtag(dictionary: hashTagDictionary))
        }
        
        return hashtags
    }
    


}
