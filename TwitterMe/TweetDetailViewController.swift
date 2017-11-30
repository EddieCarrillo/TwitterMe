//
//  TweetDetailViewController.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/29/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    
    @IBOutlet weak var profilePictureImageView: UIImageView! //Done
   
    @IBOutlet weak var profileNameLabel: UILabel! // Done
    
    @IBOutlet weak var handleNameLabel: UILabel! //Done
    
    @IBOutlet weak var tweetTextLabel: UILabel! //Done
    
    @IBOutlet weak var mediaView: UIView! //TODO
    
    @IBOutlet weak var createdAtLabel: UILabel! //Done
    
    @IBOutlet weak var retweetNumberLabel: UILabel! //Done
    
    @IBOutlet weak var favoritesNumberLabel: UILabel! //Done
    
    
    var tweet: Tweet? {
        didSet{
            guard let tweet = self.tweet else {
               print("User assigned tweet as nil value. [WEIRD BUG]")
            
            }
            
            if let tweetOwner = tweet.owner {
                if let profilePictureUrl = tweetOwner.profileUrl {
                    self.profilePictureImageView.setImageWith(profilePictureUrl)
                }else {
                    print("ERROR USING URL")
                }
               
            }else {
               print("ERROR LOADING USER!")
            }
            
             self.profileNameLabel.text = tweet.ownerName
             self.tweetTextLabel = tweet.text
            
            self.createdAtLabel = getFormattedDateString()
            
             self.retweetNumberLabel.text =  "\(tweet.retweetCount)"
             self.favoritesNumberLabel.text = "\(tweet.favortiesCount)"
            self.handleNameLabel.text = "\(tweet.owner.screenname)"
  
        }
        
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getFormattedDateString(tweet: Tweet) -> String {
        
        guard let date = tweet.timeStamp else {
            print("Could not get the timestamp")
            return ""
        }
        
        
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeString = dateFormatter.string(from: tweet.timeStamp)
        
        dateFormatter.dateFormat = "dd MMM YY"
        let dateString = dateFormatter.string(from: tweet.timeStamp)
        
        
        return "\(timeString) · \(dateString)"
    
    
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
