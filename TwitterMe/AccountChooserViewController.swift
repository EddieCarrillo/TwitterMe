//
//  AccountChooserViewController.swift
//  TwitterMe
//
//  Created by my mac on 12/22/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class AccountChooserViewController: UIViewController {

    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    
    
    
    
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func addExistingAccountTapped(_ sender: Any) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()

        // Do any additional setup after loading the view.
    }
    

    func initNavBar(){
        let editButton = self.leftBarButton.customView as! UIButton
        let doneButton = self.rightBarButton.customView as! UIButton
        
        editButton.addTarget(self, action: #selector(editMenu), for: UIControlEvents.touchUpInside)
        
        doneButton.addTarget(self, action: #selector(accountChosen), for: UIControlEvents.touchUpInside)
    }
    
    
    @objc func editMenu(){
        
    }
    
    @objc func accountChosen(){
        
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
