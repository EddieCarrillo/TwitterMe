//
//  LogoutViewController.swift
//  TwitterMe
//
//  Created by my mac on 12/22/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        User.logout()
        
        
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
