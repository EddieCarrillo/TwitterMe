//
//  MenuBarContainerViewController.swift
//  TwitterMe
//
//  Created by Eddie on 12/18/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class MenuBarContainerViewController: UIViewController {
    
    
    var user: User? {
        didSet{
            guard let user = self.user else {
                   print("The user is nil")
                return
                
            }
            
            updateGui()
        }
        
    }
    
    @IBOutlet weak var menuBarView: MenuBarView!
    
    @IBOutlet weak var menuBarLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var blurOverlayView: UIView!
    
    @IBOutlet var blurTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    
    @IBOutlet var profileTabGestureRecognizer: UITapGestureRecognizer!
    
    
    @IBOutlet weak var profileTabView: UIView!
    
    
    var isMenuShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabs()
        
        self.user = User.currentUser
        
        //Get access to navigation controller and detect event when user tapped profile button on navbar
        let controlNavigationController = childViewControllers[0] as! CentralNavigationController
        
        profileTabGestureRecognizer.addTarget(self, action: #selector(onProfileTabTapped))
        
        
    
        //If the user taps the nav bar button then toggle the menu...
                controlNavigationController.navBarButtonTapped = {
            self.toggleMenu()
        }
        
        
        setupBlurOverlay()
        
    }
    
    func setupBlurOverlay(){
       self.blurOverlayView.translatesAutoresizingMaskIntoConstraints = false
        //Detect user tapped.
        self.blurOverlayView.isUserInteractionEnabled = true
        
        self.blurTapGestureRecognizer.addTarget(self, action: #selector(tappedOverlay))
        
        self.blurOverlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.blurOverlayView.isHidden = true
    }

    
    //TODO: Review animations.
    func toggleMenu(){
        
        if isMenuShowing {
            self.menuBarLeadingConstraint.constant = -343.00
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }else {
            
            self.menuBarLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            
            
        }
        blurOverlayView.isHidden = !blurOverlayView.isHidden
        isMenuShowing = !isMenuShowing
        
    }
    
    func tappedOverlay(){
        self.toggleMenu()
    }
    
    func initTabs(){
        
        profileTabGestureRecognizer.addTarget(self, action: #selector(onProfileTabTapped))
        
        
    }
    
    func onProfileTabTapped(){
        let controlNavigationController = childViewControllers[0] as! CentralNavigationController
        controlNavigationController.profileTabTapped?()
        //Close the menu after clicking the profile tab
        self.toggleMenu()
        
    }
    
    func updateGui(){
        
        guard let user = self.user else {
            print("Could not get user.")
            return
        }
        
        self.usernameLabel.text = user.name
        if let screenName = user.screenname {
            self.screenNameLabel.text = screenName
        }
        self.followersCountLabel.text = "\(self.user?.followersCount ?? 0)"
        self.followingCountLabel.text = "\(self.user?.followingCount  ?? 0)"
        
        self.profileImageView.setImageWith((self.user?.profileUrl)!, placeholderImage: UIImage(named: "profile-Icon"))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




