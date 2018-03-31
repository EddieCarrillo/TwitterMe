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
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.backgroundColor = UIColor.red
        self.navigationBar.isTranslucent = true

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
    
    
    func getNavBarHeight() -> CGFloat{
        return self.navigationBar.frame.height
    }
    
    
    
    

    
    
}
