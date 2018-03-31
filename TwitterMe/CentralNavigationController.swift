//
//  CentralNavigationController.swift
//  
//
//  Created by Eddie on 12/18/17.
//

import UIKit

class CentralNavigationController: UINavigationController {
    
    
    
    var navBarButtonTapped: (() -> (Void))?
    var profileTabTapped: (() -> (Void))?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let navbar = self.navigationBar
        
        UINavigationBar.appearance().backgroundColor = UIColor.red
        self.navigationBar.tintColor = UIColor.red
        self.navigationBar.barTintColor = UIColor.red
        var tabBarController: HomeTabBarController?
        
        for viewController in viewControllers {
            if (viewController is HomeTabBarController) {
                tabBarController = viewController as! HomeTabBarController
            }
        }
        
        guard let homeTabBarController = tabBarController else {
            print("Tab bar controller was not found.")
            return
        }
        
        profileTabTapped = {
            homeTabBarController.profileTabPressed?()
        }
        
        
        
        
    }
    
    
    
    

    
    
}
