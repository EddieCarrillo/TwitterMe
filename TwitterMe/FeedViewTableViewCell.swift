//
//  FeedViewTableViewCell.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/7/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
//TODO: Add retweet view.
class FeedViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var replyNumberLabel: UILabel!
    
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var retweetNumberLabel: UILabel!
    
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteNumberLabel: UILabel!
    
    @IBOutlet weak var privateMessageImageView: UIImageView!
    
    @IBOutlet weak var retweetOwnerLabel: UILabel!
    
    @IBOutlet weak var retweetedView: UIView!
    
    @IBOutlet weak var mediaView: UIView!
    
    
    var displayedTweet: Tweet?
    
    
    @IBAction func onReplyTapped(_ sender: Any) {
        //TODO: This makes no sense.
        self.replyButton.isSelected = !self.replyButton.isSelected
        
        
        
    }
    
    
    @IBAction func onRetweetTapped(_ sender: Any) {
        
        guard let tweet = self.displayedTweet else{
            print("Could not load tweet for some reason")
            return
            
        }
        //Updates tweet locally and at the server level
        tweet.toggleRetweet()
        
        //Update the UI
        self.retweetButton.isSelected = tweet.retweeted
        self.updateStats()

    }
    
    
    @IBAction func onLikeTapped(_ sender: Any) {
        guard let tweet = self.displayedTweet else {
            print("Could not access the tweet")
            return
        }
        
        //Updates tweet locally and at the server level
        tweet.toggleFavorite()
        
        //Update the UI
        self.favoriteButton.isSelected = tweet.favorited
        
        self.updateStats()
        
        
        
    }
    
    
    
    
    var tweet: Tweet?{
        
        didSet{
            guard let tweet = self.tweet else {
                print("Woah, some weirdness just happened.")
                return;
            }
            
            checkForRetweet()
            updateUI()
            
            
            
           
    
    }
    
  
        
    }
    
    
    func updateUI(){
        
        guard let tweet = self.displayedTweet else {
            print("Could not load display tweet.")
            return
        }
        
        
        
        //Update the UI.
        //  self.profilePictureImageView =
        self.nameLabel.text = tweet.ownerName
        
        if let handle = tweet.handle {
            self.handleLabel.text = "@\(handle)"
            
        }
        
        
        initButtons()
        self.dateLabel.text = tweet.dateText
        self.tweetTextLabel.text = tweet.text
        updateStats()
        self.profilePictureImageView.isUserInteractionEnabled = true
        self.profilePictureImageView.setRounded()
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
    
    func checkForRetweet(){
        guard let tweet = self.tweet else {
            print("Could not load tweet!")
            return
        }
        
        if !tweet.isRetweet {
            self.retweetedView.isHidden = true
            self.displayedTweet = self.tweet
        }else {
            //We need to display retweeted tweet not intermediary tweet
            self.displayedTweet = tweet.retweetedStatus
            setupRetweetView()
            
        }
        
    }
    
    
    //Function assumes that tweet is a retweet
    func setupRetweetView(){

        self.retweetedView.isHidden = false

        guard let tweet = self.tweet else {
            print("Could not load the tweet!")
            return
        }

        guard let owner = tweet.owner else {
            print("Could not load the owner!")
            return
        }

        guard let ownerName = owner.name else {
            print("Could not load ther owner name.")
            return
        }

        self.retweetOwnerLabel.text = "\(ownerName) retweeted"


    }
    
    
    
    
    func updateStats(){
        
        guard let tweet = self.tweet else {
            return
        }
        self.favoriteNumberLabel.text = "\(tweet.favoritesCount)"
        self.retweetNumberLabel.text = "\(tweet.retweetCount)"
        self.replyNumberLabel.text = "\(tweet.replyCount)"
    }
    
    func initButtons(){
        let favoritedButtonImage = UIImage(named: "favor-icon-red")
        let unfavoritedButtonImage = UIImage(named: "favor-icon")
        
        let retweetedIconImage = UIImage(named: "retweet-icon-green")
        let unretweetedIconImage = UIImage(named: "retweet-icon")
        
        self.favoriteButton.setImage(unfavoritedButtonImage, for: UIControlState.normal)
        self.favoriteButton.setImage(favoritedButtonImage, for: .selected)
        
        self.retweetButton.setImage(unretweetedIconImage, for: .normal)
        self.retweetButton.setImage(retweetedIconImage, for: .selected)
        
        self.retweetButton.isSelected = (tweet?.retweeted) ?? false
        self.favoriteButton.isSelected = (tweet?.favorited) ?? false
        
        
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
