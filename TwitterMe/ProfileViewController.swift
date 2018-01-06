//
//  ProfileViewController.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/9/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import ImageViewer

class ProfileViewController: UIViewController  {
    
    
    var user: User?
    var tweets: [Tweet] = []

    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var profileView: ProfileView!
    
    var lastPressedCell: FeedViewTableViewCell?

    
    let feedViewCellReuseId = "FeedViewTableViewCell"
    let profileFeedCellReuseId = "ProfileFeedTableViewCell"
    let profileSegue = "ProfileSegue"
    let tweetDetailSegue = "ProfileTweetDetailSegue"
    let composeTweetSegue = "ComposeTweetSegue"
    
    
    var currentGalleryItems: [GalleryItem] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            self.user = User.currentUser
        }
        
        guard let currentUser = self.user else  {
            print("Trouble loading user.")
            return
        }
        //We don't want title appearing for profile screen.
        if let tabBarController = self.parent{ // If this is true this means that it is nested in tab bar
           tabBarController.navigationItem.title = ""
        }
        
        
        //self.navigationItem.title = "Profile"
        transparentBar()
       // self.navigationController?.navigationBar.isHidden = false
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.estimatedRowHeight = 100
        //Add autolayout
        self.tableview.rowHeight = UITableViewAutomaticDimension
        //Update the GUI (For the top half of the screen.)
        profileView.user = currentUser
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.loadTweets(user: currentUser, sucess: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableview.reloadData()
        }, failure: { (error: Error) in
            print("[ERROR]: \(error)")
        })
        
        
        

        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Should notify cells to stop playing videos
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopVideos"), object: nil)
        
    }
    
    
     func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        print("Profile picture tapped.")
        lastPressedCell = sender.view?.superview?.superview as! FeedViewTableViewCell?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        prepare(profileViewController: profileViewController)
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
    
    
     func didTapName(_ sender: UITapGestureRecognizer) {
        print("Profile name tapped")
        didTapProfilePicture(sender)
        
//        lastPressedCell = sender.view?.superview?.superview as! FeedViewTableViewCell?
//        let parent = self.parent
        //let tabBarController = parent as! HomeTabBarController
        //Bug fix open retweeted tweet's owner's profile
      //  tabBarController.profilePictureTapped?((lastPressedCell?.displayedTweet?.owner)!)
        
        
    }
    
    func refreshTimeline(_ refreshControl: UIRefreshControl){
        let twitterClient = TwitterClient.sharedInstance
        
        let successBlock: () -> () = {
            refreshControl.endRefreshing()
        }
        
        let failure: ()->() = {
            refreshControl.endRefreshing()
            
        }
        refreshControl.beginRefreshing()
        
        refreshData(success: successBlock, failureBlock: failure)
        
        
    }
    
    func refreshData(success: @escaping()->(), failureBlock: @escaping () -> ()){
        let twitterClient = TwitterClient.sharedInstance
        guard let user = user else  {
            return
        }
        
        twitterClient?.loadTweets(user: user, sucess: { (tweets: [Tweet]) in
            self.tweets = tweets
        }, failure: { (error: Error) in
            print("error: \(error)")
        })
        
    }
    
    
    func transparentBar() {
       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == profileSegue {
            if let profileViewController = segue.destination as? ProfileViewController{
               prepare(profileViewController: profileViewController)
            }
        }else if segue.identifier == tweetDetailSegue {
            if let  tweetDetailViewController = segue.destination as? TweetDetailViewController{
                let lastPressed = lastPressedCell
                tweetDetailViewController.tweet = lastPressed?.tweet
            }else if let navigationController = segue.destination as? UINavigationController{
                if let  tweetDetailViewController = navigationController.viewControllers.first as? TweetDetailViewController{
                    let lastPressed = lastPressedCell
                    tweetDetailViewController.tweet = lastPressed?.tweet
                }
            }
        }else if segue.identifier == composeTweetSegue {
            if let composeTweetViewController  = segue.destination as? ComposeTweetViewController{
                composeTweetViewController.user = User.currentUser!
                composeTweetViewController.finished = {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    
    func prepare(profileViewController vc: ProfileViewController){
        let lastPresed = lastPressedCell
        vc.user = lastPresed?.tweet?.owner
    }
    
    
    
}
    

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tweets.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileFeedCellReuseId ) as! FeedViewTableViewCell
        cell.imageViewTapped = { (index: Int, images: [UIImage]) in
            
            self.currentGalleryItems = self.imagesToGallery(images: images)
            
            //Need to set gallery items before initializing view controller
            let galleryViewController = GalleryViewController(startIndex: index, itemsDatasource: self, displacedViewsDatasource: nil, configuration: self.galleryConfiguration())
            
            self.present(galleryViewController, animated: true, completion: {
                print("[SHOWING GVC]")
            })
        }
        
        
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        //Duct tape bug fix.
        cell.mediaView.frame = CGRect(x: cell.mediaView.frame.origin.x, y: cell.mediaView.frame.origin.y, width: cell.mediaView.frame.width, height: CGFloat(cell.defaultMediaViewHeight))
        
        let tweet = tweets[indexPath.row]
        
        let tapGestureNameLabel = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.didTapName(_:)))
        cell.nameLabel.addGestureRecognizer(tapGestureNameLabel)
        
        let tapGestureProfilePicture = UITapGestureRecognizer(target: self, action: #selector (FeedViewController.didTapName(_:)))
        cell.profilePictureImageView.addGestureRecognizer(tapGestureProfilePicture)
        
        
        
        cell.tweet = tweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.lastPressedCell = cell as! FeedViewTableViewCell
        print("[DIDSELECTINDEXPATH]")
        
        self.performSegue(withIdentifier: tweetDetailSegue, sender: nil)
        
        
    }
    
}


extension ProfileViewController: GalleryItemsDatasource {
    
    //Neccesary for DataSource
    func itemCount() -> Int {
        return currentGalleryItems.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return currentGalleryItems[index]
    }
    
    
    //Helper functions
    func galleryConfiguration() -> GalleryConfiguration {
        return [GalleryConfigurationItem.closeLayout(ButtonLayout.pinLeft(0, 0)),
                GalleryConfigurationItem.itemFadeDuration(0.2)]
    }
    
    func imagesToGallery(images: [UIImage]) -> [GalleryItem] {
        var items: [GalleryItem] = []
        for image in images {
            
            let galleryItem = GalleryItem.image(fetchImageBlock: {
                $0(image)
            })
            
            items.append(galleryItem)
        }
        
        return items
    }
    
}



