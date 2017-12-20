//
//  UIViewExtensions.swift
//  TwitterMe
//
//  Created by Eddie on 12/18/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

extension UIImageView{
    
    
    func setRounded(){
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        //Dont' know what this does.
        self.layer.masksToBounds = true
        
    }
    
}
