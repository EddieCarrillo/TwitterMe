//
//  FeedViewController.swift
//  TwitterMe
//
//  Created by my mac on 11/6/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let feedViewCellReuseId = "FeedViewTableViewCell"
    let profileSegue = "ProfileSegue"
    let tweetDetailSegue = "TweetDetailSegue"
    let composeTweetSegue = "ComposeTweetSegue"
    var tweets: [Tweet] = []
    
    var lastPressedCell: FeedViewTableViewCell?
    var refreshControl: UIRefreshControl?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        //Bind action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshTimeline(_:)
            ), for: UIControlEvents.valueChanged)
        
        //add refresh to table view
        self.tableView.insertSubview(refreshControl, at: 0)
        
        //Add initial data to feed
        self.refreshData(success: {}, failureBlock: {})
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        //Add autolayout
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        //Have to access parent view controller (tab bar controller) because this view controller is nested in
        self.parent?.title = "Home"
        // transparentBar()
        
        setupNavigationBar()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavigationBar()
        
    }
    

    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        print("Profile picture tapped.")
        lastPressedCell = sender.view?.superview?.superview as! FeedViewTableViewCell?
        self.performSegue(withIdentifier: profileSegue, sender: nil)
        
    }
    
    
    @IBAction func didTapName(_ sender: UITapGestureRecognizer) {
        print("Profile name tapped")
        
        lastPressedCell = sender.view?.superview?.superview as! FeedViewTableViewCell?
        

          self.performSegue(withIdentifier: profileSegue, sender: nil)
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
        
        twitterClient?.homeTimeline(success: { (tweets: [Tweet]) in
            //Default behavior
                self.tweets = tweets
                self.tableView.reloadData()
            //Injectable behavior
            success()
                
        }, failure: { (error: Error) in
            print("[ERROR]: \(error)")
            //Injectible behavior
            failureBlock()
        })
        
    }
    
    func setupNavigationBar(){
        
        
        
        //Set up left button
        let defaultProfileImage: UIImage = UIImage(named: "profile-Icon")! //Use default image
//        let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        profileButton.titleLabel?.text = nil
        
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        if let currentUser = User.currentUser {
//            profileButton.setImageFor(.normal, with: currentUser.profileUrl!, placeholderImage: defaultProfileImage)
//            profileButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//            
            profileImageView.setImageWith(currentUser.profileUrl!, placeholderImage: defaultProfileImage)
            profileImageView.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        
        profileImageView.gestureRecognizers = []
        
        profileImageView.gestureRecognizers?.append(UITapGestureRecognizer(target: self, action: #selector(didTapProfileBar)))
        
        profileImageView.isUserInteractionEnabled = true
        
//        profileButton.addTarget(self, action: #selector(didTapProfileBar), for: .touchUpInside)
        
        //Set up right button
        
        let composeTweetButton = UIButton(type: .system)
        let composeTweetImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        composeTweetImageView.image = UIImage(named: "edit-icon")
        //Add Action
        composeTweetImageView.gestureRecognizers = []
        composeTweetImageView.gestureRecognizers?.append(UITapGestureRecognizer(target: self, action: #selector(onComposeTweetButtonTapped)))
        
       
        
        //We don't want title appearing for profile screen.
        if let tabBarController = self.parent{ // If this is true this means that it is nested in tab bar
            tabBarController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
            tabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeTweetImageView)
            tabBarController.navigationItem.title = "Home"
        }
        
        composeTweetButton.addTarget(self, action: #selector(FeedViewController.onComposeTweetButtonTapped), for: UIControlEvents.touchUpInside)
        
        
        
        
    }
    
    func didTapProfileBar(){
        guard let centralNavigationController = self.parent?.parent as? CentralNavigationController else {
            print("Could not get the central navigationc controller")
            return
        }
        
        centralNavigationController.navBarButtonTapped?()
        
        
    }
    
    func onComposeTweetButtonTapped(){
        print("Compose tweet button tapped")
        self.performSegue(withIdentifier: self.composeTweetSegue, sender: nil)
    }
    
    func transparentBar() {
        let transparentPixel = UIImage(named: "TransparentPixel")
        
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.setBackgroundImage(transparentPixel, for: UIBarMetrics.default)
        
        navigationBar?.shadowImage = transparentPixel
        
        navigationBar?.backgroundColor  = UIColor.clear
        
        navigationBar?.isTranslucent  = true
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedViewCellReuseId) as!FeedViewTableViewCell
        
        let tweet = tweets[indexPath.row]
        
        let tapGestureNameLabel = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.didTapName(_:)))
        cell.nameLabel.addGestureRecognizer(tapGestureNameLabel)
        
        let tapGestureProfilePicture = UITapGestureRecognizer(target: self, action: #selector (FeedViewController.didTapName(_:)))
        cell.profilePictureImageView.addGestureRecognizer(tapGestureProfilePicture)
        
        
        cell.tweet = tweet
        
        
        return cell

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.lastPressedCell = cell as! FeedViewTableViewCell
        
        
        self.performSegue(withIdentifier: tweetDetailSegue, sender: nil)
        
        
    }
    
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == profileSegue {
            if let profileViewController = segue.destination as? ProfileViewController{
                let lastPresed = lastPressedCell
                
                profileViewController.user = lastPresed?.tweet?.owner
            }
        }else if segue.identifier == tweetDetailSegue {
            if let  tweetDetailViewController = segue.destination as? TweetDetailViewController{
                let lastPressed = lastPressedCell
                tweetDetailViewController.tweet = lastPressed?.tweet
            }
        }else if segue.identifier == composeTweetSegue {
            if let composeTweetViewController  = segue.destination as? ComposeTweetViewController{
                composeTweetViewController.user = User.currentUser!
            }
            
        }
    }
    

}
