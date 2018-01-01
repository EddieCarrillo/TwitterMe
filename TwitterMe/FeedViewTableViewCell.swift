//
//  FeedViewTableViewCell.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/7/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import AVKit
import ActiveLabel

//TODO: Add retweet view.
class FeedViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    
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
    
    @IBOutlet weak var mediaViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var retweetViewTopConstraint: NSLayoutConstraint!
    
    
    var videoPlayTriggered: ((AVPlayerViewController,AVPlayer)->())?
    
    var displayedTweet: Tweet?
    
    var player: AVPlayer?
    
    var playerController: AVPlayerViewController?
    
    var playerLayer: AVPlayerLayer?
    
    let defaultMediaViewHeight = 120
    
    
    
    
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
            self.translatesAutoresizingMaskIntoConstraints = false
            
            checkForRetweet()
            updateUI()
            setupTweetMedia()
        
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
        
        print("isActive \(tweetTextLabel is ActiveLabel)")
    
        self.tweetTextLabel.handleHashtagTap { (hashtag: String) in
            print("hashtag character tapped: \(hashtag)")
        }
        
        
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
            hideRetweetView()
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
    
    
    func setupTweetMedia(){
        guard let tweet = self.displayedTweet else {
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
            self.mediaViewHeightConstraint.constant = 0
            self.mediaView.isHidden = true
            return
        }
        
        self.mediaView.isHidden = false
        self.mediaViewHeightConstraint.constant = CGFloat.init(self.defaultMediaViewHeight)
        //If the medias is not nil then we are guaranteed the first element is not nil
        let media = medias[0]
        
        
        if let mediaType = media.type {
            if mediaType == Media.videoType{
                setupTweetVideo(media: media)
            }else if mediaType == Media.animatedGIFType {
                setupAnimatedGIF(media: media)
            }else {
                setupImage(media: media)
            }
        }
        
        print("[MEDIATYPE] :\(media.type!)")
        
        
        
    }
    
    
    func setupImage(media: Media){
        
        
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
        
        //self.mediaViewHeightConstraint.constant = (self.mediaView.frame.size.width * CGFloat.init(imageHeight)) / CGFloat.init(imageWidth)
        
        
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
        print("[SUBVIEW WAS ADDDED]")
        
        
        
    }
    
    func setupAnimatedGIF(media: Media){
        guard let videoInfo = media.videoInfo else {
            print("Could not retrieve the video info!")
            return
        }
        
        guard let variants: [[String: Any]] = videoInfo.variants else {
            print("Variants could not be extracted correctly")
            return
        }
        
        guard let firstVideoType = variants.first else {
            print("There is no animated GIF video type")
            return
        }
        
        guard let urlString = firstVideoType[VideoInfo.urlKey] as? String else {
            print("Could not extract url string")
            return
        }
        
        guard let mediaUrl = URL(string: urlString) else {
            print("Could not load the URL correctly")
            return
        }
        
        
        //Create a new player
        self.player = AVPlayer(url: mediaUrl)
        
        //Create a player layer
        let playerLayer = AVPlayerLayer(player: player)
        //Keep aspect ratio
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        
        //TODO: Investigate this bug. (Can't just assign frame of media view to playerLayer frame)
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.mediaView.frame.width, height: self.mediaView.frame.height)
        //        //Resize player layer dimensions to media view dimensions
        //            playerLayer.frame = self.mediaView.frame
        
        //Don't mess with the video at the end.
        player?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        //Start the animated_gif
        player?.play()
        
        
        //Insert the player into the view
        self.mediaView.layer.insertSublayer(playerLayer, at: 0)
        
        //Create a callback for the event so that when the video stops it replays again.
        NotificationCenter.default.addObserver(self, selector: #selector(TweetDetailViewController.playerItemReachedEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    
    func playerItemReachedEnd(notification: NSNotification){
        //reset the gif to 0
        player?.seek(to: kCMTimeZero)
    }
    
    func setupTweetVideo(media: Media){
        print("Play video triggered!")
        
        guard let videoInfo = media.videoInfo else {
            print("Could not retrieve video info!")
            return
        }
        
        guard let variants: [[String: Any]] = videoInfo.variants else {
            print("variants was not extracted ")
            return
        }
        
        //Choose first version of the video
        guard let firstVideoType = variants.first else {
            print("There is no video type")
            return
        }
        
        guard let urlString = firstVideoType[VideoInfo.urlKey] as? String else {
            print("Could not find url string.")
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("Could not get URL")
            return
        }
        
        
        
        //Create a new player, passing it an HTTP Live Streaming Url
        self.player = AVPlayer(url: url)
        
        //Create a new AVPlayerViewController and pass a reference to the player.
        self.playerController = AVPlayerViewController()
        
        playerController?.player = player
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetDetailViewController.playVideo))
        self.mediaView.gestureRecognizers = []
        self.mediaView.gestureRecognizers?.append(tapGesture)
        
        addVideoPreviewPicture(media: media)
        
    }
    
    func playVideo(){
        
        
        
        
        guard let vc = self.playerController, let videoPlayer = self.player else {
            print("Player controller")
            return
        }
        
        
        videoPlayTriggered?(vc, videoPlayer)
       
    }
    
    func addVideoPreviewPicture(media: Media){
        setupImage(media: media)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Remove any subviews (Possibly any image views.)
        for subview in self.mediaView.subviews {
            subview.removeFromSuperview()
        }
        //Remove tap gestures
        self.mediaView.gestureRecognizers = []
        
        self.retweetViewTopConstraint.constant = 2
        
        //Reset the media view size
        self.mediaViewHeightConstraint.constant = CGFloat.init(self.defaultMediaViewHeight)
        self.mediaView.isHidden = false
        //Remove any possible sublayers (An AVPlayerLayer, for example)
        if let sublayers = self.mediaView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        //self.mediaView.layoutSubviews()
       
    }
    
    func hideRetweetView(){
        self.retweetViewTopConstraint.constant = -34
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        print("The cell was selected.")
        // Configure the view for the selected state
    }

}
