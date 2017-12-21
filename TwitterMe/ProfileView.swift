//
//  ProfileView.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/20/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var backgroundPictureImageView: UIImageView!

    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileHandleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    
    
    
    var user: User?{
    
        didSet{
            guard let user = self.user else {
                print("Something weird happened. User set a nil user")
                 return
            }
            
            if let profileName = user.name {
                self.profileNameLabel.text = profileName
            }
            
            if let profileHandle = user.screenname {
                self.profileHandleLabel.text =  "@\(profileHandle)"
            }
            
            if let bio = user.tagline {
                 self.bioLabel.text = bio
            }
            
            if let followingNumber = user.followingCount {
                let followingNumberText = "\(followingNumber)"
                self.followingNumberLabel.text = followingNumberText
            }
            
            if let followersNumber = user.followersCount {
                let followersNumberText  = "\(followersNumber)"
                self.followingNumberLabel.text = followersNumberText
            }
//            
            if let profileUrl = user.profileUrl {
                self.profilePictureImageView.setImageWith(profileUrl)
                   self.profilePictureImageView.setRounded()
            }
            
            if let backgroundPictureUrl  = user.backgroundProfileUrl {
                self.backgroundPictureImageView.setImageWith(backgroundPictureUrl)
//                self.profilePictureImageView.setImageWith(backgroundPictureUrl)
                print("[BACKGROUND_PICTURE_URL] SUCCESS")

            }else {
               print("[BACKGROUND_PICTURE_URL] could not set image with url")
            }
            
        }
    
    }
    
    
}
