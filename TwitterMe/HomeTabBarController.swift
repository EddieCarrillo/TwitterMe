//
//  HomeTabBarController.swift
//  TwitterMe
//
//  Created by Eddie on 12/20/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    static let profileSegue = "ProfileSegue"
    
    var profileTabPressed: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTabPressed = {
            self.performSegue(withIdentifier: HomeTabBarController.profileSegue, sender: nil)
        }

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == HomeTabBarController.profileSegue {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = User.currentUser!
        }
        
    }
 

}
