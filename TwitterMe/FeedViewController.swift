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
    var tweets: [Tweet] = []
    
    var lastPressedCell: FeedViewTableViewCell?

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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        //Add autolayout
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //Have to access parent view controller (tab bar controller) because this view controller is nested in
        self.parent?.title = "Home"
        
        
       // transparentBar()
        
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("[ERROR] \(error)")
        })
        
        
        
        

        // Do any additional setup after loading the view.
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
        }
    }
    

}
