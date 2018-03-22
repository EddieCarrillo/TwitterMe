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
    
    
    static let consumerKey = "mzSyEAqq9ZXq2YY1oPqp9w3Sl"
    static let consumerSecret = "bAXVji8LnO7DTrG3Ut8XEJtTkEPl3hF6YhseVB1kUbNyUZlKmG"
   
    static let sharedInstance =  TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    
    
    /*URLS*/
    let homeTimelineEndpoint = "1.1/statuses/home_timeline.json?count=100"
    let saveTweetEndpoint = "/1.1/statuses/update.json"
    let userTimelineEndpoint = "/1.1/statuses/user_timeline.json?count=100"
    let loginVerifyEndpoint = "1.1/account/verify_credentials.json"
    let oauthTokenEndpoint = "oauth/request_token"
    let retweetEndpoint = "1.1/statuses/retweet"
    let unretweetEndpoint = "1.1/statuses/unretweet"
    let favoriteEndpoint = "1.1/favorites/create"
    let getFavoritesEndpoint = "1.1/favorites/list.json"
    let unfavoriteEndpoint = "1.1/favorites/destroy"
    
   // let oauthAccessTokenEndpoint = ""
    
    
    var loginSucess: (()->())?
    var failure:  ((Error) -> ())?

    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
    
        get(homeTimelineEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
          
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    
    }
    
    
    func saveTweet(user: User, tweetText: String, success: @escaping()->(), failure: @escaping (Error)->()){
        
        var queryParameters: [String: Any] = [:]
        queryParameters["status"]  = tweetText
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient?.post(saveTweetEndpoint, parameters: queryParameters, progress: { (progess: Progress) in
            print("progress: \(progess.completedUnitCount)")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("[ERROR] \(error)")
            failure(error)
        }
        
    }
    
    
    func loadTweets(user: User, sucess: @escaping (([Tweet]) -> ()), failure : @escaping (Error) -> ()){
        //TODO: Make sure works, possible
        let twitterClient = TwitterClient.sharedInstance
        var queryParams : [String: Any] = [:]
        queryParams["screen_name"] = (user.screenname)!
        
        twitterClient?.get(userTimelineEndpoint, parameters: queryParams, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> () in
            let dictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionary)
            
            sucess(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            failure (error)
        })
        
    }
    
    
//    func loadTweets(for user: User, success: @escaping([Tweet]) -> (), failure: @escaping(Error) -> ()){
//        
//        var queryParams: [String: Any] = [:]
//        queryParams["screen_name"]  = user.name!
//        queryParams["user_id"] = user.dictionary?["id"] 
//        
//        
//       
//        get("1.1/statuses/user_timeline.json", parameters: queryParams, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            print("RESPONSE: \(response) \n\n\n\n\n\n\n")
//            
//            guard let tweetDictionaries = response as? [NSDictionary] else {
//                 print("Could not extract dictionaries from data.")
//                return
//            }
//            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
//            success(tweets)
//        }) { (task : URLSessionDataTask?, error: Error) in
//            print("An error has occurred. \(error)")
//            failure(error)
//        }
//    
//    }
    
    
    
    
    func getImage(with url: URL, success: @escaping (UIImage) -> (), failure: @escaping (Error) -> ()){
        let urlSession  = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: url) { (unwrappedData, response , error) in
            if let error = error {
                failure(error)
            }else if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                print("status code: \(statusCode)")
                
                if let data = unwrappedData{
                    OperationQueue().addOperation {
                        if  let image = UIImage(data: data){
                            OperationQueue.main.addOperation {
                                success(image)
                            }
                        }else {
                            failure(NSError(domain: "Could not convert data to image", code: 404, userInfo: nil))
                        }
                
                    }
                }else {
                    failure(NSError(domain: "Could not get data from server", code: 404, userInfo: nil))
                }
            }else {
                failure(NSError(domain: "Could not get a response", code: 404, userInfo: nil))
            }
        }.resume()
    }
    
    func getFavoritesList(for user: User,success: @escaping([Tweet]) -> () , failure: @escaping (Error)->()){
        var screenname = ""
        if let name = user.screenname {
            screenname = name
        }else {
            print("user has no screen name!")
        }
        
        var params: [String: Any] = [:]
        params["screen_name"] = screenname
        get(getFavoritesEndpoint, parameters:params , success: { (task: URLSessionDataTask, response: Any?) in
            if let response = response as? [NSDictionary]{
                let tweets = Tweet.tweetsWithArray(dictionaries: response)
                success(tweets)
            }else {
                print("Could not get a valid response")
                
            }
        }) { (dataTask, error) in
             failure(error)
        }
    }
    
    func currentAccount( success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get(loginVerifyEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //  print("response: \(response)")
            
            
            if  let userDictionary = response as? NSDictionary{
                let user = User(dictionary: userDictionary)
                print("[NAME]: \(user.name)")
                success(user)
            }else {
                failure(NSError(domain: "No user dictionary", code: 404, userInfo: nil))
            }
            
          
    
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("[ERROR]: \(error)")
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL){
        
        let requestToken =  BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("received the access token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser  = user // Save the current user
                self.loginSucess!()

            }, failure: { (error: Error) in
                self.failure?(error)
            })
            
            
            
        }, failure: { (error: Error?) in
            print("[ERROR] \(error?.localizedDescription)")
            self.failure!(error!)
        })
        
        
    
    }
    
    func favoriteTweet(tweet: Tweet, success: @escaping()->(), failure: @escaping(Error) -> ()){
        let tweetId: Int = tweet.id
        var queryParams: [String: Any] = [:]
        queryParams["id"] = tweetId
        
        self.post("\(favoriteEndpoint).json", parameters: queryParams, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    func unFavoriteTweet(tweet: Tweet, success: @escaping()->(), failure: @escaping(Error) -> ()){
        let tweetId: Int = tweet.id
        var queryParams: [String: Any] = [:]
        queryParams["id"] = tweetId
        
        self.post("\(unfavoriteEndpoint).json", parameters: queryParams, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    func retweet(tweet: Tweet, success: @escaping()->(), failure: @escaping(Error) -> ()){
        let tweetId: Int = tweet.id
        
        self.post("\(retweetEndpoint)/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    func unRetweet(tweet: Tweet, success: @escaping()->(), failure: @escaping(Error) -> ()){
        let tweetId: Int = tweet.id
        
        self.post("\(unretweetEndpoint)/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error)->()){
        //Make sure to logout first....
        
        
     //   TwitterClient.sharedInstance?.deauthorize()
        self.loginSucess = success
        self.failure = failure
        
        
        //Now we need a request token so we can show twitter that we are the actual app not some random 3rd party app or loser who lives with his mom
        fetchRequestToken(withPath: oauthTokenEndpoint, method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil
            , success: { (reqToken: BDBOAuth1Credential?) in
                guard let requestToken = reqToken?.token else {
                    print("No token received ::")
                    return;
                }
                print ("I got a token!")
                print("request token: \(requestToken)")
                //Go to url where user will be able to login
                guard  let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken)") else {
                    print("Could not create URL.")
                    return
                }
                
                
                UIApplication.shared.open(authorizeUrl, options: [:], completionHandler: { (success: Bool) in
                    if (success){
                        print("Successfully finished opening the url")
                    }
                })
                
                
                
        }, failure: { (error: Error?) in
            if let error = error{
                self.failure?(error)
                print("[ERROR]: \(error.localizedDescription)")
            }
            
        })
    }
    
}
