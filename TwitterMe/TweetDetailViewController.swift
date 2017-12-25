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
    

    
    @IBOutlet weak var mediaViewHeightConstraint: NSLayoutConstraint!
    
    var tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePictureImageView.setRounded()
        setupTweetImage()
        
        updateGUI()

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
        let timeString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd MMM YY"
        let dateString = dateFormatter.string(from: date)
        
        
        return "\(timeString) · \(dateString)"
    
    
    }
    
    
    
    func updateGUI(){
        guard let tweet = self.tweet else {
            print("User assigned tweet as nil value. [WEIRD BUG]")
            return
        }
        
        if let tweetOwner = tweet.owner {
            if let profilePictureUrl = tweetOwner.profileUrl {
                self.profilePictureImageView.setImageWith(profilePictureUrl)
            }else {
                print("ERROR USING URL")
            }
            
            if let screenName = tweetOwner.screenname {
                self.handleNameLabel.text = "@\(screenName)"
            }

        }else {
            print("ERROR LOADING USER!")
        }
        
        self.profileNameLabel.text = tweet.ownerName
        self.tweetTextLabel.text = tweet.text
        
        self.createdAtLabel.text = getFormattedDateString(tweet: tweet)
        
        self.retweetNumberLabel.text =  "\(tweet.retweetCount)"
        self.favoritesNumberLabel.text = "\(tweet.favoritesCount)"
    
        
    }
    
    
    
    
    func setupTweetImage(){
        guard let tweet = self.tweet else {
             print("Could load the tweet")
            return
        }
        
        guard let entity = tweet.entities else {
            print("Could not load tweet entitites")
            return
        }
        
        guard let medias = entity.media else {
             print("Could not load the tweet media")
            //Hide the media view
            self.mediaView.isHidden = true
            self.mediaViewHeightConstraint.constant = 0
            return
        }
        
        let media = medias[0]
        print("media type: \(media.type)")
        print("medias count: \(medias.count)")
        
        
        var mediaImageView = UIImageView()
        
        
        
        var imageHeight = 0
        var imageWidth = 0
        var scaling = Size.scalingFit
        
        if let photoSizes = media.sizes {
            if let largeSize = photoSizes.large {
                imageHeight = largeSize[Size.heightKey] as! Int
                imageWidth = largeSize[Size.widthKey] as! Int
                scaling = largeSize[Size.scalingKey] as! String
            }
        }
        
        self.mediaViewHeightConstraint.constant = (self.mediaView.frame.size.width * CGFloat.init(imageHeight)) / CGFloat.init(imageWidth)
        
        
        if let mediaUrl = media.mediaUrlHttps {
            mediaImageView.setImageWith(URL(string: mediaUrl)!)
            print("mediaUrl: \(mediaUrl)")
        }else {
              print("Could not get the url ")
              self.mediaView.isHidden = true
              self.mediaViewHeightConstraint.constant = 0
            return
        }
        
    //    mediaView = mediaImageView
        mediaImageView.frame = CGRect(x: 0, y: 0, width: mediaView.frame.width, height: mediaView.frame.height)
        
        if scaling == Size.scalingFit {
            mediaImageView.contentMode = .scaleAspectFit
        }else {
            mediaImageView.contentMode = .scaleToFill
        }
        
        mediaView.addSubview(mediaImageView)
        print("[SUBVIEW WAS ADDDE]")
        
        
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
