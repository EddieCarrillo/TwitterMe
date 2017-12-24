//
//  Media.swift
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation

class Media {
    
    //URL of the media to display to clients. Example: 
    //"display_url":"pic.twitter.com/rJC5Pxsu"
    
    var displayUrl: String?
    
    //An expanded version of display_url. Links to the media display page. Example:
    var expandedUrl: String?
    
    //ID of the media expressed as a 64-bit integer. Example: "id":114080493040967680
    var id: Int?
    
    //ID of the media expressed as a string. Example:
    
    //"id_str":"114080493040967680"
    var idStr: String?
    
    
    //An array of integers indicating the offsets within the Tweet text where the URL begins and ends. The first integer represents the location of the first character of the URL in the Tweet text. The second integer represents the location of the first non-URL character occurring after the URL (or the end of the string if the URL is the last part of the Tweet text). Example:
    var indices: [Int]?
    
    
//    An http:// URL pointing directly to the uploaded media file. Example:
//    
//    "media_url":"http://p.twimg.com/AZVLmp-CIAAbkyy.jpg"
//    For media in direct messages, media_url is the same https URL as media_url_https and must be accessed via an authenticated twitter.com session or by signing a request with the user’s access token using OAuth 1.0A. It is not possible to directly embed these images in a web page.
    var mediaUrl: String?
    
    
    //See above
    var mediaUrlHttps: String?
    
    var size: Size
    
    
    
    //Nullable. For Tweets containing media that was originally associated with a different tweet, this ID points to the original Tweet. Example:
    
  //  "source_status_id": 205282515685081088
    var sourceStatusId: Int?
    
    
    //Type of uploaded media. Possible types include photo, video, and animated_gif. Example:
    //"type":"photo"
    var type: String?

}
