//
//  FeedViewTableViewCell.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/7/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class FeedViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var replyImageView: UIImageView!
    
    @IBOutlet weak var replyNumberLabel: UILabel!
    
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var retweetNumberLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var favoriteNumberLabel: UILabel!
    
    @IBOutlet weak var privateMessageImageView: UIImageView!
    
    
    
   
    
    var tweet: Tweet?{
        
        didSet{
            guard let tweet = self.tweet else {
                print("Woah, some weirdness just happened.")
                return;
            }
            
            
            
            //Update the UI.
          //  self.profilePictureImageView =
            self.nameLabel.text = tweet.ownerName
            
            if let handle = tweet.handle {
                self.handleLabel.text = "@\(tweet.handle)"

            }
            self.dateLabel.text = tweet.dateText
            self.tweetTextLabel.text = tweet.text
            self.favoriteNumberLabel.text = "\(tweet.favoritesCount)"
            self.retweetNumberLabel.text = "\(tweet.retweetCount)"
            self.profilePictureImageView.isUserInteractionEnabled = true
            self.nameLabel.isUserInteractionEnabled = true
            if let owner = tweet.owner {
                if let profilePictureUrl = owner.profileUrl {
                    print("Profile picture successfully set.")
                    self.profilePictureImageView.setImageWith(profilePictureUrl)
                }else {
                    print("Could not load user url")
                }
            }else {
                print("Could not tweet owner")
            }
           
            
            
           
        }
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        print("The cell was selected.")
        // Configure the view for the selected state
    }

}
