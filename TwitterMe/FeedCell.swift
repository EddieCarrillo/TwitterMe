//
//  FeedCell.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 2/8/18.
//  Copyright © 2018 ecproductions. All rights reserved.
//

import UIKit
import AVKit
import ActiveLabel



import AVKit
import ActiveLabel



enum TwitterColors {
    static let blue = UIColor(red: (29.0/255), green: 160.0/255, blue: 242.0/255, alpha: 1.0)
}

class FeedCell: UITableViewCell {

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
    
    
    //Top message indictated tweet is being retweeted
    @IBOutlet weak var retweetOwnerLabel: UILabel!
    
    @IBOutlet weak var retweetOwnerLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedImageView: UIImageView!
    
    @IBOutlet weak var retweeetImageViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var mediaView: UIView!
    
    @IBOutlet weak var mediaViewHeightConstraint: NSLayoutConstraint!
    
    
    
    var imageViewTapped: ((Int, [UIImage]) -> ())?
    
    var pressedUserHandle: ((String) -> ())?
    var pressedTwitterLink: ((URL) -> ())?
    
    var videoPlayTriggered: ((AVPlayerViewController,AVPlayer)->())?
    
    var displayedTweet: Tweet?
    
    var player: AVPlayer?
    
    var playerController: AVPlayerViewController?
    
    var playerLayer: AVPlayerLayer?
    
    let defaultMediaViewHeight = 120
    let defaultRetweetedImageViewHeight = 12
    let defaultRetweetedLabelHeight = 14
    
    
    
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
            
            //When view controller is not showing turn off all videos.
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "StopVideos"), object: nil, queue: OperationQueue.main) { (notification: Notification) in
                self.pauseVideo()
            }
            
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
        
        self.tweetTextLabel.URLColor = TwitterColors.blue
        self.tweetTextLabel.hashtagColor = TwitterColors.blue
        self.tweetTextLabel.mentionColor = TwitterColors.blue
        
        
        
        self.tweetTextLabel.handleHashtagTap { (hashtag: String) in
            print("hashtag character tapped: \(hashtag)")
        }
        
        self.tweetTextLabel.handleURLTap { (url) in
            print("url tapped: \(url.absoluteString)")
            if let pressedLink = self.pressedTwitterLink {
                pressedLink(url)
            }else {
                print("No behavior defined for pressing handle!")
            }
        }
        
        self.tweetTextLabel.handleMentionTap { (handle) in
            print("user with handle: @\(handle) pressed!")
           if let pressedHandle = self.pressedUserHandle{
                pressedHandle(handle)
           }else {
            print("No behavior defined for pressing handle!")
            }
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
        
        self.retweetOwnerLabel.text = "\(ownerName) Retweeted"
        
        showRetweetView()
        
        
    }
    
    
    func showRetweetView(){
        self.retweetOwnerLabelHeight.constant = CGFloat(self.defaultRetweetedLabelHeight)
        self.retweeetImageViewHeight.constant = CGFloat(self.defaultRetweetedImageViewHeight)
        
    }
    
    
    
    
    
    func updateStats(){
        
        guard let tweet = self.displayedTweet else {
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
            //Hide the media view
            self.mediaViewHeightConstraint.constant = 0
            return
        }
        
        guard let entity = tweet.entities else {
            print("Could not load tweet entitites")
            //Hide the media view
            self.mediaViewHeightConstraint.constant = 0
            return
        }
        
        guard let medias = entity.media else {
            print("Could not load the tweet media")
            //Hide the media view
            self.mediaViewHeightConstraint.constant = 0
            //self.mediaView.isHidden = true
            return
        }
        
        // self.mediaView.isHidden = false
        self.mediaViewHeightConstraint.constant = CGFloat.init(self.defaultMediaViewHeight)
        //If the medias is not nil then we are guaranteed the first element is not nil
        let media = medias[0]
        
        
        if let mediaType = media.type {
            if mediaType == Media.videoType{
                setupTweetVideo(media: media)
            }else if mediaType == Media.animatedGIFType {
                setupAnimatedGIF(media: media)
            }else {
                setupImages(medias: medias)
            }
        }
        
        print("[MEDIATYPE] :\(media.type!)")
        
        
        
    }
    
    
    func setupImages(medias: [Media]){
        
        if medias.count == 1 {
            setupOneImage(medias: medias)
        }else if medias.count == 2 {
            setupTwoImage(medias: medias)
        }else if medias.count == 3 {
            setupThreeImage(medias: medias)
        }else if medias.count == 4 {
            setupFourImage(medias: medias)
        }
        //
        //
        //        var mediaImageView = UIImageView()
        //
        //
        //
        //        var imageHeight = 0
        //        var imageWidth = 0
        //        var scaling = Size.scalingFit
        //
        //        if let photoSizes = media.sizes {
        //            if let largeSize = photoSizes.large {
        //                imageHeight = largeSize[Size.heightKey] as! Int
        //                imageWidth = largeSize[Size.widthKey] as! Int
        //                scaling = largeSize[Size.scalingKey] as! String
        //            }
        //        }
        //
        //        //self.mediaViewHeightConstraint.constant = (self.mediaView.frame.size.width * CGFloat.init(imageHeight)) / CGFloat.init(imageWidth)
        //
        //
        //        if let mediaUrl = media.mediaUrlHttps {
        //            mediaImageView.setImageWith(URL(string: mediaUrl)!)
        //            print("mediaUrl: \(mediaUrl)")
        //        }else {
        //            print("Could not get the url ")
        //            self.mediaView.isHidden = true
        //            self.mediaViewHeightConstraint.constant = 0
        //            return
        //        }
        //
        //        //    mediaView = mediaImageView
        //        mediaImageView.frame = CGRect(x: 0, y: 0, width: mediaView.frame.width, height: mediaView.frame.height)
        //
        //        if scaling == Size.scalingFit {
        //            mediaImageView.contentMode = .scaleAspectFit
        //        }else {
        //            mediaImageView.contentMode = .scaleToFill
        //        }
        //
        //        mediaView.addSubview(mediaImageView)
        //        print("[SUBVIEW WAS ADDDED]")
        //
        //
        
    }
    
    
    func setupOneImage(medias: [Media]){
        let media = medias[0]
        
        let photoViewFrame = self.mediaView.bounds
        
        let onePhotoView = OnePhotoMedia(frame: photoViewFrame)
        onePhotoView.imageTapped = imageViewTapped
        if let urlString = media.mediaUrlHttps {
            onePhotoView.photoURL = URL(string: urlString)
        }else {
            print("No url string")
        }
        
        mediaView.addSubview(onePhotoView)
    }
    
    
    func setupTwoImage(medias: [Media]){
        let firstMedia = medias[0]
        let secondMedia = medias[1]
        //Set up the size of the custom view
        let photoViewFrame = self.mediaView.bounds
        
        let twoPhotoView = TwoPhotoView(frame: photoViewFrame)
        twoPhotoView.imageTapped = imageViewTapped
        
        if let firstUrlString = firstMedia.mediaUrlHttps {
            twoPhotoView.firstURL = URL(string: firstUrlString )
        }else {
            print("[ERROR] No first url string")
        }
        
        if let secondUrlString = secondMedia.mediaUrlHttps {
            twoPhotoView.secondURL = URL(string: secondUrlString)
        }else {
            print("[ERROR] No first url string")
        }
        
        mediaView.addSubview(twoPhotoView)
        
    }
    
    
    func setupThreeImage(medias: [Media]){
        let firstMedia = medias[0]
        let secondMedia = medias[1]
        let thirdMedia = medias[2]
        //Set up the size of the custom view
        let photoViewFrame = self.mediaView.bounds
        
        let threePhotoView = ThreePhotoView(frame: photoViewFrame)
        threePhotoView.imageTapped = imageViewTapped
        
        if let firstUrlString = firstMedia.mediaUrlHttps {
            threePhotoView.firstURL = URL(string: firstUrlString )
        }else {
            print("[ERROR] No first url string")
        }
        
        if let secondUrlString = secondMedia.mediaUrlHttps {
            threePhotoView.secondURL = URL(string: secondUrlString)
        }else {
            print("[ERROR] No first url string")
        }
        
        if let thirdUrlString = thirdMedia.mediaUrlHttps {
            threePhotoView.thirdURL = URL(string: thirdUrlString)
        }else {
            print("[ERROR] No first url string")
        }
        
        mediaView.addSubview(threePhotoView)
    }
    
    
    func setupFourImage(medias: [Media]){
        
        let firstMedia = medias[0]
        let secondMedia = medias[1]
        let thirdMedia = medias[2]
        let fourthMedia = medias[3]
        //Set up the size of the custom view
        let photoViewFrame = self.mediaView.bounds
        
        let fourPhotoView = FourPhotoView(frame: photoViewFrame)
        fourPhotoView.imageTapped = imageViewTapped
        
        if let firstUrlString = firstMedia.mediaUrlHttps {
            fourPhotoView.firstURL = URL(string: firstUrlString )
        }else {
            print("[ERROR] No first url string")
        }
        
        if let secondUrlString = secondMedia.mediaUrlHttps {
            fourPhotoView.secondURL = URL(string: secondUrlString)
        }else {
            print("[ERROR] No first url string")
        }
        
        if let thirdUrlString = thirdMedia.mediaUrlHttps {
            fourPhotoView.thirdURL = URL(string: thirdUrlString)
        }else {
            print("[ERROR] No first url string")
        }
        
        
        if let fourthURLString = fourthMedia.mediaUrlHttps {
            fourPhotoView.fourthURL = URL(string: fourthURLString)
        }else {
            print("[ERROR] No first url string")
        }
        
        
        mediaView.addSubview(fourPhotoView)
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
        
        
        let animatedViewFrame = self.mediaView.bounds
        
        let animatedView = AnimatedView(frame: animatedViewFrame)
        self.mediaView.addSubview(animatedView)
        
        animatedView.isGIF = true
        animatedView.videoURL = mediaUrl
        animatedView.player?.play()
        
        
        
        
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
        
        
        let animatedViewFrame = self.mediaView.bounds
        let animatedView = AnimatedView(frame: animatedViewFrame)
        //
        
        
        if let previewPhotoURLString = media.mediaUrlHttps{
            animatedView.previewPhotoURL = URL(string: previewPhotoURLString)
        }
        
        animatedView.videoURL = url
        
        
        
        animatedView.isGIF = false
        
        self.mediaView.addSubview(animatedView)
        
        
        //        //Create a new player, passing it an HTTP Live Streaming Url
        //        self.player = AVPlayer(url: url)
        //
        //        //Create a new AVPlayerViewController and pass a reference to the player.
        //        self.playerController = AVPlayerViewController()
        //
        //        playerController?.player = player
        //
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetDetailViewController.playVideo))
        //        self.mediaView.gestureRecognizers = []
        //        self.mediaView.gestureRecognizers?.append(tapGesture)
        //
        //        addVideoPreviewPicture(media: media)
        
    }
    
    func playVideo(){
        
        var uncheckedAnimatedView: AnimatedView?
        
        for subview in self.mediaView.subviews {
            if subview is AnimatedView{
                uncheckedAnimatedView = subview as? AnimatedView
            }
        }
        
        guard let animatedView = uncheckedAnimatedView else {
            print("Could not load animated view")
            return
        }
        
        
        
        
        guard let vc = self.playerController, let videoPlayer = animatedView.player else {
            print("Player controller")
            return
        }
        
        
        videoPlayTriggered?(vc, videoPlayer)
        
    }
    
    func addVideoPreviewPicture(media: Media){
        setupOneImage(medias: [media])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellContent()
    }
    
    
    func pauseVideo(){
        var uncheckedAnimatedView: AnimatedView?
        
        for subview in self.mediaView.subviews {
            if subview is AnimatedView{
                uncheckedAnimatedView = subview as? AnimatedView
            }
        }
        
        guard let animatedView = uncheckedAnimatedView else {
            print("Could not load animated view")
            return
        }
        
        animatedView.pause()
        
        
    }
    
    func resetCellContent(){
        //Remove any subviews (Possibly any image views.)
        for subview in self.mediaView.subviews {
            subview.removeFromSuperview()
        }
        //Remove tap gestures
        self.mediaView.gestureRecognizers = []
        
        
        
        //Reset the media view size
        self.mediaViewHeightConstraint.constant = CGFloat.init(self.defaultMediaViewHeight)
        self.mediaView.isHidden = false
        //Remove any possible sublayers (An AVPlayerLayer, for example)
        if let sublayers = self.mediaView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func hideRetweetView(){
        self.retweeetImageViewHeight.constant = 0
        self.retweetOwnerLabelHeight.constant = 0
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        print("The cell was selected.")
        // Configure the view for the selected state
    }
    
    
    
}
    

