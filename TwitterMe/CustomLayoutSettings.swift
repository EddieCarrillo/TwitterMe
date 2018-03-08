//
//  CustomLayoutSettings.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 3/7/18.
//  Copyright © 2018 ecproductions. All rights reserved.
//

import Foundation
import UIKit


class CustomLayoutSettings {
    
    init(){
        itemSize = nil
        headerViewSize = nil
        menuSize = nil
        isHeaderStetchy = false
        isAlphaOnHeaderActive = false
        headerOverlayMaxAlpha = 0
        isMenuSticky = false
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        maxParallaxOffset = 0
    }
    
    //Sizes
    //Individual size of elements in cell
    var itemSize: CGSize?
    var headerViewSize: CGSize?
    var menuSize: CGSize?
    
    //Actions/Behaviors
    var isHeaderStetchy: Bool
    var isAlphaOnHeaderActive: Bool
    var headerOverlayMaxAlpha: CGFloat
    var isMenuSticky: Bool
    
    //Manage spacing
    var minimumInteritemSpacing: CGFloat
    var minimumLineSpacing: CGFloat
    var maxParallaxOffset: CGFloat
    
    
    
}


