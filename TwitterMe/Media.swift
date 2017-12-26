//
//  Media.swift
//  TwitterMe
//
//  Created by my mac on 12/23/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation

class Media {
    
    
    
    
    static let photoType = "photo"
    static let videoType = "video"
    static let animatedGIFType = "animated_gif"
    
    //URL of the media to display to clients. Example: 
    //"display_url":"pic.twitter.com/rJC5Pxsu"
    
    var displayUrl: String?
    let displayUrlKey = "display_url"
    
    //An expanded version of display_url. Links to the media display page. Example:
    var expandedUrl: String?
    let expandedUrlKey = "expanded_url"
    //ID of the media expressed as a 64-bit integer. Example: "id":114080493040967680
    var id: Int?
    let idKey = "id"
    
    //ID of the media expressed as a string. Example:
    
    //"id_str":"114080493040967680"
    var idStr: String?
    let idStrKey = "id_str"
    
    
    //An array of integers indicating the offsets within the Tweet text where the URL begins and ends. The first integer represents the location of the first character of the URL in the Tweet text. The second integer represents the location of the first non-URL character occurring after the URL (or the end of the string if the URL is the last part of the Tweet text). Example:
    var indices: [Int]?
    let indicesKey = "indices"
    
    
//    An http:// URL pointing directly to the uploaded media file. Example:
//    
//    "media_url":"http://p.twimg.com/AZVLmp-CIAAbkyy.jpg"
//    For media in direct messages, media_url is the same https URL as media_url_https and must be accessed via an authenticated twitter.com session or by signing a request with the user’s access token using OAuth 1.0A. It is not possible to directly embed these images in a web page.
    var mediaUrl: String?
    let mediaUrlKey = "media_url"
    
    
    //See above
    var mediaUrlHttps: String?
    let mediaUrlHttpsKey = "media_url_https"
    
    
    
    var sizes: Size?
    let sizesKey = "sizes"
    
    
    
    //Nullable. For Tweets containing media that was originally associated with a different tweet, this ID points to the original Tweet. Example:
    
  //  "source_status_id": 205282515685081088
    var sourceStatusId: Int?
    let sourceStatusIdKey = "source_status_id"
    
    
    //Type of uploaded media. Possible types include photo, video, and animated_gif. Example:
    //"type":"photo"
    var type: String?
    let typeId = "type"
    
    var videoInfo: VideoInfo?
    let videoInfoKey = "video_info"
    
    
    
    
    
    init(dictionary: NSDictionary){
        if let displayUrl = dictionary[displayUrlKey] as? String {
             self.displayUrl = displayUrl
        }
        
        if let expandedUrl = dictionary[expandedUrlKey] as? String {
            self.expandedUrl = expandedUrl
        }
        
        if let id = dictionary[idKey] as? Int {
            self.id = id
        }
        
        if let idString = dictionary[idStrKey] as? String {
            self.idStr = idString
        }
        
        if let indices = dictionary[indicesKey] as? [Int]{
            self.indices = indices
        }
        
        if let mediaUrl = dictionary[mediaUrlKey] as? String {
            self.mediaUrl = mediaUrl
        }
        
        if let mediaUrlHttps = dictionary[mediaUrlHttpsKey] as? String {
             self.mediaUrlHttps = mediaUrlHttps
        }
        
        if let sizesDictionary = dictionary[sizesKey] as? NSDictionary {
            self.sizes = Size(dictionary: sizesDictionary)
        }
        
        if let sourceStatusId = dictionary[sourceStatusIdKey] as? Int {
            self.sourceStatusId = sourceStatusId
        }
        
        if let type = dictionary[typeId] as? String {
            self.type = type
        }
        
        if let videoInfoDictionary = dictionary[videoInfoKey] as? NSDictionary {
            self.videoInfo = VideoInfo(dictionary: videoInfoDictionary)
        }
        
    }
    
    
    class func toMediaArray(from mediaDictionaries: [NSDictionary]) -> [Media] {
        var medias: [Media] = []
        
        for mediaDictionary in mediaDictionaries {
             medias.append(Media(dictionary: mediaDictionary))
        }
        
        return medias
    }

}
