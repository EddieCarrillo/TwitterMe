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
    
    //User profile
    var user: User?
    //Tweets for feed of timeline
    var tweets: [Tweet] = []
    
    var currentData: [Tweet] = []{
        didSet{
            OperationQueue.main.addOperation {
            self.tableview.reloadData()

            }
        }
    }

    
    //normal tweets feed may add more later
    @IBOutlet weak var tableview: UITableView!
    
    //MARK- REUSE ID's
    let feedViewCellReuseId = "FeedViewTableViewCell"
    let profileFeedCellReuseId = "ProfileFeedTableViewCell"
    let profileSegue = "ProfileSegue"
    let tweetDetailSegue = "ProfileTweetDetailSegue"
    let composeTweetSegue = "ComposeTweetSegue"
    let reusableFeedCellId = "com.ecarrillo.FeedCell"
   
    //Keep track of last cell pressed by user
    var lastPressedCell: FeedCell?
    
    
    @IBOutlet weak var headerView: ProfileHeaderView!
    
    //This refers to images used when user taps on media inside tweet.
    var currentGalleryItems: [GalleryItem] = []

    @IBOutlet weak var tweetsSegementedControl: UISegmentedControl!
    
    @IBAction func onSegmentChanged(_ sender: Any) {
        let segmentValue = tweetsSegementedControl.selectedSegmentIndex
        
        if (segmentValue == 0){
            currentData = tweets
        }else if (segmentValue == 1){
         currentData = tweets.filter({ (tweet) -> Bool in
                //If the tweet has not media then return false
                if tweet.entities?.media == nil{
                    return false
                }
                    return true
            })
            
        }else {
            
            if let user = user {
                TwitterClient.sharedInstance?.getFavoritesList(for: user, success: { (tweets) in
                    self.currentData = tweets
                }, failure: { (error) in
                    print(error)
                })
            }
            
            
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Nil only when view controller was not navigated to.
        if user == nil {
            self.user = User.currentUser
        }
        // If the current user is not loaded then this app has bigger problems to deal with
        guard let currentUser = self.user else  {
            print("Trouble loading user.")
            return
        }
        
        initTableViews()
        //We don't want title appearing for profile screen.
        if let tabBarController = self.parent{ // If this is true this means that it is nested in tab bar
           tabBarController.navigationItem.title = ""
        }

        //self.navigationItem.title = "Profile"
        transparentBar()
       // self.navigationController?.navigationBar.isHidden = false
        initSegmentedControl()  
        updateGUI(user: currentUser)
        loadTweets()
        
    }
    
    func initSegmentedControl(){
        tweetsSegementedControl.setTitle("Tweets", forSegmentAt: 0)
        tweetsSegementedControl.setTitle("Media", forSegmentAt: 1)
        tweetsSegementedControl.setTitle("Favorites", forSegmentAt: 2)
    }
    
    func initTableViews(){
        tableview.delegate = self
        updateHeaderWithConstraints()
        //Register cell
        tableview.register(UINib(nibName: "FeedCell", bundle: Bundle.main), forCellReuseIdentifier: self.reusableFeedCellId)
        self.tableview.dataSource = self
        self.tableview.estimatedRowHeight = 100
        //Add autolayout
        self.tableview.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func loadTweets(){
        guard let currentUser = self.user else  {
            print("Trouble loading user.")
            return
        }
        
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.loadTweets(user: currentUser, sucess: { (tweets: [Tweet]) in
            self.tweets = tweets
            //By default we will let the current to be displayed regulat tweets
            self.currentData = tweets
            
            self.tableview.reloadData()
        }, failure: { (error: Error) in
            print("[ERROR]: \(error)")
        })
    }
    
    
    func updateGUI(user: User){
        headerView.user = user
        headerView.onTappedSettingsButton = {
            self.showLogoutAlert()
        }
    }
    
    func showLogoutAlert(){
        let alertController = UIAlertController(title: "Do you want to logout?", message:
            "", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Log out", style: UIAlertActionStyle.destructive) { (action) in
            //Handle the case when the user logs out
            User.logout()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            //Handle case of canceling Doing nothing will just dismiss the view
        }
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            print("Woo woo")
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit(){
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        //To redraw the table header view ... I think
        tableview.tableHeaderView = headerView
    }
    
    
    
    
    func updateHeaderWithConstraints(){
        let offset = tableview.contentOffset.y
        let base = CGFloat(0)
        
        var bannerPosition = CGFloat(headerView.headerTopDefault)
        var bannerHeight = CGFloat(headerView.bannerDefaultHeight)
        
        if offset < base {
          bannerPosition = offset
          bannerHeight = CGFloat(headerView.bannerDefaultHeight) - offset
            blurImage()
        }else {
            reverseBlur()
        }
        
        headerView.headerTopConstraint.constant = bannerPosition
        headerView.bannerHeightConstraint.constant = bannerHeight
        
        
        
    }
    
    
    func blurImage(){
        guard let image = headerView.profileBanner.image, let cgimg = image.cgImage else {
            print("Image view does not have image")
            return
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(3, forKey: kCIInputRadiusKey)
        
        if let filteredCIImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let filteredImage = UIImage(ciImage: filteredCIImage)
            
            headerView.profileBanner.image = filteredImage
            
        }
    }
    
    
    func reverseBlur(){
        self.headerView.profileBanner.image = self.headerView.bannerImage
    }
    
    
    
    

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Should notify cells to stop playing videos
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopVideos"), object: nil)
        
    }
    
    
     func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        print("Profile picture tapped.")
        lastPressedCell = sender.view?.superview?.superview as! FeedCell?
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


extension ProfileViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // updateHeaderView()
        updateHeaderWithConstraints()
    }
}
    

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentData.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableFeedCellId ) as! FeedCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
        
        let tweet = currentData[indexPath.row]
        
        let tapGestureNameLabel = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.didTapName(_:)))
        cell.nameLabel.addGestureRecognizer(tapGestureNameLabel)
        
        let tapGestureProfilePicture = UITapGestureRecognizer(target: self, action: #selector (FeedViewController.didTapName(_:)))
        cell.profilePictureImageView.addGestureRecognizer(tapGestureProfilePicture)
        
        
        
        cell.tweet = tweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.lastPressedCell = cell as! FeedCell
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



