//
//  ProfileHeaderView.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 3/19/18.
//  Copyright © 2018 ecproductions. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
   

    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    
    
    
    let headerTopDefault = 0.0
    let headerViewHeight: CGFloat = 360
    let bannerDefaultHeight = 180.0

    
    var user: User?{
        didSet{
            guard let profileOwner = user else{
                print("No user ")
                return;
            }
            updateGUI(user: profileOwner)
            
            
        }
    }
    
    
    func updateGUI(user: User){
        
        if let profileName = user.name {
            self.usernameLabel.text = profileName
        }
        
        if let profileHandle = user.screenname {
            self.handleLabel.text =  "@\(profileHandle)"
        }
        
        if let bio = user.tagline {
            self.bioLabel.text = bio
        }
        
        if let followingNumber = user.followingCount {
            let followingNumberText = "\(followingNumber)"
            self.followingCountLabel.text = followingNumberText
        }
        
        if let followersNumber = user.followersCount {
            let followersNumberText  = "\(followersNumber)"
            self.followersCountLabel.text = followersNumberText
        }
        //
        if let profileUrl = user.profileUrl {
            self.profilePicture.setImageWith(profileUrl)
            self.profilePicture.setRounded()
        }
        
        if let backgroundPictureUrl  = user.backgroundProfileUrl {
            self.profileBanner.setImageWith(backgroundPictureUrl)
            //                self.profilePictureImageView.setImageWith(backgroundPictureUrl)
            print("[BACKGROUND_PICTURE_URL] SUCCESS")
            
        }else {
            print("[BACKGROUND_PICTURE_URL] could not set image with url")
        }
        
    }
    
    
    

    
    

    


    
    

}