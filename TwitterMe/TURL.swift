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
    let displayUrlKey = "display_url"
    
    /*Expanded version of `` display_url`` . Example:
     
     "expanded_url":"http://bit.ly/2so49n2"*/
    
    var expandedUrl: String?
    let expandedUrlKey = "expanded_url"
    
    
    /*An array of integers representing offsets within the Tweet text where the URL begins and ends. The first integer represents the location of the first character of the URL in the Tweet text. The second integer represents the location of the first non-URL character after the end of the URL. Example:*/
    var indices: [Int]?
    let indicesKey = "indices"
    
    
    /* The fully unwound version of the link including the tweet*/
    var url: String?
    let urlKey = "url"
    
    //HTTP Response code
    var status: Int?
    let statusKey = "status"
    
    //HTML title for the link
    var title: String?
    let titleKey = "title"
    
    //HTML description for the link
    var description: String?
    let descriptionKey = "description"
    
    
    init(dictionary: NSDictionary){
        if let disUrl = dictionary[displayUrlKey] as? String{
             self.displayUrl = disUrl
        }
        
        if let expUrl = dictionary[expandedUrlKey] as? String{
            self.expandedUrlKey = expUrl
        }
        
        if let indices = dictionary[indicesKey] as? [Int]{
            self.indices = indices
        }
        
        if let url = dictionary[urlKey] as? String {
            self.url = url
        }
        
        if let status = dictionary[statusKey] as? String {
            self.status = status
        }
        
        if let title = dictionary[titleKey] as? String{
            self.title = title
        }
        
        if let description = dictionary[descriptionKey] as? String{
            self.description = description
        }
        
        
    }
    
    class func toUrlArray(urlDictionaries: [NSDictionary]) -> [TURL] {
        
        let urls: [TURL] = []
        
        for urlDictionary in urlDictionaries {
             urls.append(TURL(dictionary: urlDictionary))
        }
    }
    
    
    

}
