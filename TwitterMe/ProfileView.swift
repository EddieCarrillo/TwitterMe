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
                self.profileNameLabel = profileName
            }
            
            if let profileHandle = user.screenname {
                self.profileHandleLabel = profileHandle
            }
            
            if let bio = user.tagline {
                 self.bioLabel = bio
            }
            
            if let followingNumber = user.followingCount {
                let followingNumberText = "\(followingNumber)"
                self.followingNumberLabel.text = followingNumberText
            }
            
            if let followersNumber = user.followersCount {
                let followersNumberText  = "\(followersNumber)"
                self.followingNumberLabel.text = followersNumberText
            }
            
            
        }
    
    }
    
    
}
