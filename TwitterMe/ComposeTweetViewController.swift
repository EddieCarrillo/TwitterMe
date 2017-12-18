//
//  ComposeTweetViewController.swift
//  TwitterMe
//
//  Created by Eddie on 12/17/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    var user: User!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var tweetTextField: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGui()
        
        initNavBar()
        
        tweetTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func initNavBar(){
        
        let saveTweetButton = UIButton(type: .system)
        
        saveTweetButton.setTitle("Tweet", for: .normal)
        
        saveTweetButton.addTarget(self, action: #selector(ComposeTweetViewController.didTapTweetButton), for: UIControlEvents.touchUpInside)
        
        let barItem = UIBarButtonItem(customView: saveTweetButton)
        
        self.navigationItem.rightBarButtonItem = barItem
        
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        
        //Remove the back arrow
        self.navigationItem.backBarButtonItem?.image = nil
        
        self.navigationItem.title = "New Tweet"
        
    }
    
    func didTapTweetButton(){
        let tweetText = self.tweetTextField.text
        //No real error handling... yet TODO
        //Perform network call and save tweet text
        let networkAPI = TwitterClient.sharedInstance
        //Not safe code...
        networkAPI?.saveTweet(user: self.user, tweetText: tweetText!
            , success: {
                print("Successfully saved tweet.")
        }, failure: { (error: Error) in
            print("Failure")
        })
        
        
        
    }
    
    func initGui(){
        self.usernameLabel.text = self.user.name
        self.handleLabel.text = "@\(self.user.screenname!)"
        self.profileImageView.setImageWith(self.user.profileUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
