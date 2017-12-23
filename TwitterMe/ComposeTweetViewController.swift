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
    
    var finished: (()->())?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGui()
        
        initNavBar()
        
        tweetTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    func initNavBar(){
        
       let saveTweetButton = UIButton(type: .system)
    
//        let saveTweetLabel = UILabel()
//        saveTweetLabel.text = "Tweet"
//        saveTweetLabel.gestureRecognizers = []
//        saveTweetLabel.frame =  CGRect(x: 0, y: 0, width: 50, height: 100)
//        saveTweetLabel.textColor = UIColor(red: (0.0), green: 122.0/255, blue: (255.0/255), alpha: 1.0)
//        saveTweetLabel.isUserInteractionEnabled = true
        
//        
//        saveTweetLabel.gestureRecognizers?.append(UITapGestureRecognizer(target: self, action: #selector(didTapTweetButton)))
        

        
        saveTweetButton.setTitle("Tweet", for: .normal)
        saveTweetButton.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        
            
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
                self.finished?()
                
        }, failure: { (error: Error) in
            print("Failure")
            let alertViewController = UIAlertController(title: "Internet Connection", message: "Please check connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                     print("Dismissed alert view controller.")
            }))
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
