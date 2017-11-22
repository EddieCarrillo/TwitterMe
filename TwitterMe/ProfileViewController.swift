//
//  ProfileViewController.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/9/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var user: User!
    var userTweets: [Tweet] = []

    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var profileView: ProfileView!
    
    let feedViewCellReuseId = "FeedViewTableViewCell"
    let profileFeedCellReuseId = "ProfileFeedTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        transparentBar()
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.estimatedRowHeight = 100
        //Add autolayout
        self.tableview.rowHeight = UITableViewAutomaticDimension
        //Update the GUI (For the top half of the screen.)
        profileView.user = user
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.loadTweets(user: user, sucess: { (tweets: [Tweet]) in
            self.userTweets = tweets
            self.tableview.reloadData()
        }, failure: { (error: Error) in
            print("[ERROR]: \(error)")
        })
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func transparentBar() {
        let transparentPixel = UIImage(named: "TransparentPixel")
        
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.setBackgroundImage(transparentPixel, for: UIBarMetrics.default)
        
        navigationBar?.shadowImage = transparentPixel
        
        navigationBar?.backgroundColor  = UIColor.clear
     //   navigationBar.
        navigationBar?.isTranslucent  = true
    
    }
    
  
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         return userTweets.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileFeedCellReuseId ) as! FeedViewTableViewCell
        
        cell.tweet = userTweets[indexPath.row]
        
        
        return cell
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
