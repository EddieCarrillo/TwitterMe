//
//  MenuBarContainerViewController.swift
//  TwitterMe
//
//  Created by Eddie on 12/18/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class MenuBarContainerViewController: UIViewController {

    @IBOutlet weak var menuBarView: UIView!
    
    @IBOutlet weak var menuBarLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var blurOverlayView: UIView!
    
    
    var isMenuShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get access to navigation controller and detect event when user tapped profile button on navbar
        let controlNavigationController = childViewControllers[0] as! CentralNavigationController
        
        
        
        //If the user taps the nav bar button then toggle the menu...
                controlNavigationController.navBarButtonTapped = {
            self.toggleMenu()
        }
        
        setupBlurOverlay()
        
    }
    
    func setupBlurOverlay(){
       self.blurOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




