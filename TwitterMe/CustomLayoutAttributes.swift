//
//  CustomLayoutAttributes.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 3/7/18.
//  Copyright © 2018 ecproductions. All rights reserved.
//

import UIKit

class CustomLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var parallax: CGAffineTransform = CGAffineTransform.identity
    var initOrigin: CGPoint = CGPoint.zero
    var headerOverlayAlpha = CGFloat(0)
    
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? CustomLayoutAttributes else {
            return super.copy(with: zone)
        }
        
       copiedAttributes.parallax = parallax
        copiedAttributes.initOrigin = initOrigin
        copiedAttributes.headerOverlayAlpha = headerOverlayAlpha
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? CustomLayoutAttributes else {
            return false
        }
        
        if NSValue(cgAffineTransform: otherAttributes.parallax) != NSValue(cgAffineTransform: parallax) || otherAttributes.initOrigin != initOrigin || otherAttributes.headerOverlayAlpha != headerOverlayAlpha {
            return false
        }
        
        return super.isEqual(object)
    }

}
