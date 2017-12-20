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
    var replyCount: Int = 0
    var favorited: Bool = false
    var retweeted: Bool = false
    var id: Int = 0
    
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
        self.favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        self.replyCount = (dictionary["reply_count"] as? Int) ?? 0
        
        self.favorited = (dictionary["favorited"] as? Bool) ?? false
        self.retweeted = (dictionary["retweeted"] as? Bool) ?? false
        self.id = (dictionary["id"] as? Int) ?? 0
        
        
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
    
    
    func toggleRetweet(){
        let api = TwitterClient.sharedInstance
        
        //Update the retweeted status on server level
        
        
        if retweeted {
            api?.unRetweet(tweet: self, success: {
                print("Successfully retweeted tweet")
            }, failure: { (error: Error ) in
                print("[ERROR] \(error)")
            })
        }else {
            api?.retweet(tweet: self, success: {
                print("Successfully retweeted tweet.")
            }, failure: { (error: Error) in
                print("[ERROR] Could not successfully retweet \n\(error)")
            })
        }
        
        
        //Update the retweeted status locally
        retweeted = !retweeted
        
    }
    
    func toggleFavorite(){
        let api = TwitterClient.sharedInstance
        
        if favorited { // If favortited then unfavorite and vice versa
            api?.unFavoriteTweet(tweet: self ,success: {
                print("Successfully unfavorited tweet")
            }, failure: { (error: Error) in
                print("[ERROR] \(error)")
            })
            
        }else {
            api?.favoriteTweet(tweet: self, success: {
                print("Syccessfully favorited tweet")
            }, failure: { (error: Error) in
                print("[ERROR]: \(error)")
            })
        }
        //Update the tweet locally
        favorited = !favorited
        
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
