//
//  TURL.swift (TwitterURL)
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation

class TURL {
    
    /*URL pasted/typed into Tweet. Example:
     
     "display_url":"bit.ly/2so49n2"*/

    var displayUrl: String?
    
    /*Expanded version of `` display_url`` . Example:
     
     "expanded_url":"http://bit.ly/2so49n2"*/
    
    var expandedUrl: String?
    
    
    /*An array of integers representing offsets within the Tweet text where the URL begins and ends. The first integer represents the location of the first character of the URL in the Tweet text. The second integer represents the location of the first non-URL character after the end of the URL. Example:*/
    var indices: [Int]?
    
    
    /* The fully unwound version of the link including the tweet*/
    var url: String?
    
    //HTTP Response code
    var status: Int?
    
    //HTML title for the link
    var title: String
    
    //HTML description for the link
    var description: String
    
    
    
    

}
