//
//  VideoInfo.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 12/25/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class VideoInfo: NSObject {
    
    
    
   var aspectRatio: [Int]?
   static let aspectRationKey = "aspect_ratio"
    
    var durationMillis: Int?
   static let durationMillisKey = "duration_millis"
    
    //Each object has three keys
    //1.) bitrate
    //2.) content_type
    //3.) url - video url
    var variants: [[String: Any]]?
    
   static let variantsKey = "variants"
    //Sub keys
   static let bitrateKey = "bitrate"
   static let contentTypeKey = "content_type"
   static let urlKey = "url"
    
   //Content type application/x-mpegURL
    static let applicationXMPEGURL = "application/x-mpegURL"
    static let videoMP4 = "video/mp4"
    
    
    init(dictionary: NSDictionary){
        if let aspectRatio = dictionary[VideoInfo.aspectRationKey] as? [Int] {
            self.aspectRatio = aspectRatio
        }
        
        if let duration = dictionary[VideoInfo.durationMillisKey] as? Int {
            self.durationMillis = duration
        }
        
        if let variants = dictionary[VideoInfo.variantsKey] as? [[String: Any]] {
            self.variants = variants
        }
        
    }

}
