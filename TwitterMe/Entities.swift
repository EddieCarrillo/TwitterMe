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
    
    var media: [Media]?
    let mediaKey = "media"
    
    
    
    
   // var polls: [Poll]?
    
    
    init(rootDictionary: NSDictionary){
        
        guard let dictionary = rootDictionary[Tweet.entitiesKey] as? NSDictionary else {
            print("Could not extract entity dictionary")
            return
        }
        
        if let htags = dictionary[hashtagsKey] as? [NSDictionary] {
            self.hashtags = Hashtag.toHashTagArray(hashtagDictionaries: htags)
        }
        
        if let urls = dictionary[urlsKey] as? [NSDictionary]{
            self.urls = TURL.toUrlArray(urlDictionaries: urls)
        }
        
        if let symbols = dictionary[symbolsKey] as? [NSDictionary] {
            self.symbols = Symbol.toSymbolArray(from: symbols)
        }
        
        
        if let extendedEntities = rootDictionary[Tweet.extendedEntitiesKey] as? NSDictionary {
            if let medias = extendedEntities[mediaKey] as? [NSDictionary] {
                self.media = Media.toMediaArray(from: medias)
            }
        }
        
        
        
    }
    
    
  
    


}
