//
//  TwitterClient.swift
//  TwitterMe
//
//  Created by my mac on 10/31/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation
import UIKit
import BDBOAuth1Manager



class TwitterClient: BDBOAuth1SessionManager{
   
    static let sharedInstance =  TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "hVQQ9kHseRNEOhVOsOqPeTXfY", consumerSecret: "6oHbCoKAZsz64CGSisAwZyQShq4TXomNupeBh3wk0jQMWXP1EW")

    
    func homeTimeline(success: ([Tweet]) -> (), failure: (Error) -> ()){
    
        twitterClient?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    
    }
    
    
    func currentAccount(){
        twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //  print("response: \(response)")
            
            
            let userDictionary = response as? NSDictionary
            
            let user = User(dictionary: userDictionary!)
            
            print("[NAME]: \(user.name)")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("[ERROR]: \(error)")
        })
    }
    
}
