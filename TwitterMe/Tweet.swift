    //
//  Tweet.swift
//  TwitterMe
//
//  Created by my mac on 11/1/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timeStamp: Date?
    var owner: User?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var ownerName: String? {
        get{
            guard let owner = self.owner else {
                 print("Something weird happened")
                return nil
            }
            
            return owner.name
            
        }
    }
    
    var handle: String? {
        get{
            guard let owner = self.owner else {
                print("Something weird happened")
                return nil
            }
            
            return owner.screenname
            
        }
    }
    
    var dateText: String? {
    
        get{
            
            guard let createdAt = timeStamp else  {
               // print("Could not get date created")
               return nil
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy" //Month/day/YEAR format
            
            return dateFormatter.string(from: createdAt)
            
        }
    
    }
    
   
    
    
    
    init(dictionary: NSDictionary){
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        if  let timestampString = dictionary["time_stamp"] as? String{
            let formatter = DateFormatter()
            
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
           self.timeStamp = formatter.date(from: timestampString) as Date?
        }
        
        if let owner = dictionary["user"] as? NSDictionary{ // BUG FIX
            self.owner = User(dictionary: owner)
        }else{
           print("Something weird happened.")
        }
      
        
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        
        return tweets
    }

}
