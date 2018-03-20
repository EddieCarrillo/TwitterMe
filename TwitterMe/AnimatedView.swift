//
//  MediaView.swift
//  MediaDisplay
//
//  Created by Eduardo Carrillo on 1/1/18.
//  Copyright © 2018 Eduardo Carrillo. All rights reserved.
//

import UIKit
import AVKit

@IBDesignable
class AnimatedView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var isGIF: Bool = false {
        didSet{
            //GIFS should be infinitely looping
            if isGIF {
                self.playButton.isHidden = true
            }else {
                self.playButton.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var previewPhoto: UIImageView!
    
    
    var videoURL: URL?{
        didSet{
            //setupVideo()
            if let previewPhotoURL = self.previewPhotoURL{
                previewPhoto.setImageWith(previewPhotoURL)
            }else {
                print("Bad photo URL")
            }
        }
    }
    
    var previewPhotoURL: URL? {
        didSet{
            if let previewPhotoURL = self.previewPhotoURL{
                previewPhoto.setImageWith(previewPhotoURL)
            }else {
                print("Bad photo URL")
            }
        }
    }
    
    
    var firstTime: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initSubviews()
    }
    
    @IBAction func onPlayTapped(_ sender: Any) {
        //Start the animated_gif
        print("Play tapped!")
        if firstTime{
           setupVideo()
            self.previewPhoto.isHidden = true
            firstTime = false
        }
        
        player?.play()
        self.playButton.isHidden = true
    }
    
    func pause(){
        
        if self.player?.timeControlStatus == AVPlayerTimeControlStatus.playing {
            self.playButton.isHidden = false
            self.player?.pause()
        }else {
            print("The video is already paused!")
        }
        
    }
    
    
    
    
    func setupVideo(){
//        let urlString = "https://devimages-cdn.apple.com/samplecode/avfoundationMediaAVFoundationQueuePlayer_HLS2/master.m3u8"
        
        guard let mediaUrl = videoURL else {
            print("Could not load the URL correctly")
            return
        }
        
        
        //Create a new player
        self.player = AVPlayer(url: mediaUrl)
        
        //Create a player layer
        let playerLayer = AVPlayerLayer(player: player)
        //Keep aspect ratio
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
        //TODO: Investigate this bug. (Can't just assign frame of media view to playerLayer frame)
        playerLayer.frame = self.bounds
        //        //Resize player layer dimensions to media view dimensions
        //            playerLayer.frame = self.mediaView.frame
        
        //Don't mess with the video at the end.
        player?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        //Insert the player into the view
        self.layer.insertSublayer(playerLayer, at: 0)
        
        //Create a callback for the event so that when the video stops it replays again.
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachedEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        if isGIF {
            self.player?.play()
        }
    }
    
    
    @objc func playerItemReachedEnd(notification: NSNotification){
        //reset the video/gif to 0
        player?.seek(to: kCMTimeZero)
        
        if (!isGIF){
            //Pause the video and show play button again
            self.player?.pause()
            self.playButton.isHidden = false
        }
        
        
        print("video ended!")
    }
    
    
    func setupOneImage(pictureURL: URL?){
        
        guard let url = pictureURL else {
            print("bad url cannot set up preview picture image")
            return
        }
        
        let photoViewFrame = bounds
        
        let onePhotoView = OnePhotoMedia(frame: photoViewFrame)
        onePhotoView.photoURL = url
        
        self.addSubview(onePhotoView)
    }
    
    
    func addVideoPreviewPicture(withURL: URL?){
        setupOneImage(pictureURL: withURL)
    }
    
    func initSubviews(){
        let nib = UINib(nibName: "AnimatedMedia", bundle: Bundle(for: type(of: self)))
        
        nib.instantiate(withOwner: self, options: nil)
        playButton.imageView?.contentMode = .scaleAspectFill
        playButton.tintColor = UIColor(displayP3Red: (29.0/255), green: (160.0/255), blue: (242.0/255), alpha: 1.0)
        contentView.frame = bounds
        addSubview(contentView)
    }
    

}
