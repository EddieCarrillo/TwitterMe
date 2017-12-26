//
//  TweetDetailViewController.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/29/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import AVKit

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
    
    var player: AVPlayer?
    
    var playerController: AVPlayerViewController?
    
    var playerLayer: AVPlayerLayer?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePictureImageView.setRounded()
        setupTweetMedia()
        
        
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
    
    
    
    
    func setupTweetMedia(){
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
        
        //Modally present the view controller and call the player's play() method when complete.
        self.present(vc, animated: true) {
            videoPlayer.play()
        }
        
    }
    
    
    func addVideoPreviewPicture(media: Media){
        setupImage(media: media)
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
