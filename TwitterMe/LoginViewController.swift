//
//  LoginViewController.swift
//  TwitterMe
//
//  Created by my mac on 10/31/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    
//    let baseu

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func onLoginTapped(_ sender: Any) {
        //Give information about base url and consumer secret and key to be placed in request header
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "hVQQ9kHseRNEOhVOsOqPeTXfY", consumerSecret: "6oHbCoKAZsz64CGSisAwZyQShq4TXomNupeBh3wk0jQMWXP1EW")
        
        
        //Make sure to logout first....
        twitterClient?.deauthorize()
        
        //Now we need a request token so we can show twitter that we are the actual app not some random 3rd party app or loser who lives with his mom
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil
            , success: { (requestToken: BDBOAuth1Credential?) in
                print ("I got a token!")
                
        }, failure: { (error: Error?) in
            if let error = error{
                print("[ERROR]: \(error.localizedDescription)")
            }
            
        })
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
