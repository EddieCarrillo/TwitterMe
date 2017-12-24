//
//  Entities.swift
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation


class Entities: NSObject {

    var hashtags: [Hashtag]?
    let hashtagsKey = "hashtags"
    
    var urls: [TURL]?
    let urlsKey = "urls"
    
    var userMentions: [UserMention]?
    let urlMentionsKey = "user_mentions"
    
    var symbols: [Symbol]?
    let symbolsKey = "symbols"
    
   // var polls: [Poll]?
    
    
    init(dictionary: NSDictionary){
        if let htags = dictionary[hashtagsKey] as? [NSDictionary] {
            self.hashtags = Hashtag.toHashTagArray(hashtagDictionaries: htags)
        }
        
        if let urls = dictionary[urlsKey] as? [NSDictionary]{
            self.urls = TURL.toUrlArray(urlDictionaries: urls)
        }
        
        if let symbols = dictionary[symbolsKey] as? [NSDictionary] {
            self.symbols = symbols
        }
        
        
    }
    
    
  
    


}
