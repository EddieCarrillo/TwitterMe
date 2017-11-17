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
    var tweets: [Tweet] = []
    
    var lastPressedCell: FeedViewTableViewCell?

    @IBAction func didTapProfilePicture(_ sender: UIImageView) {
        print("Go to user profile")
        lastPressedCell = sender.superview?.superview as! FeedViewTableViewCell?
        self.performSegue(withIdentifier: feedViewCellReuseId, sender: nil)
        
    }
    @IBAction func didTapName(_ sender: Any) {
        print("Go to user profile")
        lastPressedCell = sender.superview?.superview as! FeedViewTableViewCell?
        
        
        let superView = sender.superview
        let superduperView = superView?.superview
        

          self.performSegue(withIdentifier: feedViewCellReuseId, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        //Add autolayout
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("[ERROR] \(error)")
        })
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: feedViewCellReuseId) as!FeedViewTableViewCell
        
        let tweet = tweets[indexPath.row]
        
        cell.tweet = tweet
        
        
        return cell

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == profileSegue {
            if let profileViewController = segue.destination as? ProfileViewController{
                profileViewController.user = lastPressedCell?.tweet?.owner
            }
        }
    }
    

}
