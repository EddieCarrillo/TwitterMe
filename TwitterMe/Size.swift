//
//  Size.swift
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation


//Contains dimensions for each size
//Each dictionary has following keys
// 'h', 'resize', 'w'
//resize can have values: "crop" and "fit"
class Size {
    
    static let scalingKey = "resize"
    static let scalingCrop = "crop"
    static let scalingFit = "fit"
    static let heightKey = "h"
    static let widthKey = "w"
    
    var thumb: [String: Any]?
    let thumbKey = "thumb"
    
    var large: [String: Any]?
    let largeKey = "large"
    
    var medium: [String: Any]?
    let mediumKey = "medium"
    
    var small: [String: Any]?
    let smallKey = "small"
    
    
    
    init(dictionary: NSDictionary){
        
        self.thumb = dictionary[thumbKey] as? [String: Any]
        self.large = dictionary[largeKey] as? [String: Any]
        self.medium = dictionary[mediumKey] as? [String: Any]
        self.small = dictionary[smallKey] as? [String: Any]
        
    }
    

}
