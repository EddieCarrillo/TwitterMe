//
//  CustomLayout.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 3/7/18.
//  Copyright © 2018 ecproductions. All rights reserved.
//

import UIKit

final class CustomLayout: UICollectionViewLayout {
    
    enum Item: String {
        case header
        case menu
        case cell
        
        var id : String {
            return self.rawValue
        }
        
        var kind: String{
            let rawVal = self.rawValue.capitalized
            return "Kind\(rawVal)"
        }
    }
    
    
    override public class var layoutAttributesClass: AnyClass{
        return CustomLayoutAttributes.self
    }
    
    override public var collectionViewContentSize: CGSize{
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }
    
    //Properties
    var layoutSettings = CustomLayoutSettings()
    private var oldBounds = CGRect.zero
    private var contentHeight = CGFloat()
    private var cache = [Item: [IndexPath: CustomLayoutAttributes]]()
    private var visibleLayoutAttributes = [CustomLayoutAttributes]()
    private var zIndex = 0
    
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat{
        return collectionView!.frame.width
    }
    
    //Look into this (size does not just include the photo )
    private var cellHeight: CGFloat{
        guard let itemSize = layoutSettings.itemSize else {
            return collectionViewHeight
        }
        
        return itemSize.height
    }
    
    private var cellWidth: CGFloat {
        guard let itemSize = layoutSettings.itemSize else {
            return collectionViewWidth
        }
        return itemSize.width
    }
    
    
    private var headerSize: CGSize {
        guard let headerSize = layoutSettings.headerViewSize else{
            return CGSize.zero
        }
        return headerSize
    }
    
    private var menuSize: CGSize {
        guard let menuSize = layoutSettings.menuSize else {
            return CGSize.zero
        }
        
        return menuSize
    }
    
    private var contentOffset: CGPoint{
        return collectionView!.contentOffset
    }
    
    
    
    override public func prepare(){
        guard let collectionView = collectionView,
            cache.isEmpty else {
                return
        }
        
        prepareCache()
        contentHeight = 0
        zIndex = 0
        oldBounds = collectionView.bounds
        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let headerAttributes = CustomLayoutAttributes(forSupplementaryViewOfKind: Item.header.kind, with: IndexPath(item: 0, section: 0))
        prepareItem(size: headerSize, type: Item.header, attributes: headerAttributes)
        
        let menuAttributes = CustomLayoutAttributes(forSupplementaryViewOfKind: Item.menu.kind, with: IndexPath(item: 0, section: 0))
        prepareItem(size: menuSize, type: .menu, attributes: menuAttributes)
        
        
        for section in 0 ..< collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let attributes = CustomLayoutAttributes(forCellWith: cellIndexPath)
                let lineInterSpace = layoutSettings.minimumLineSpacing
                attributes.frame = CGRect(x: 0 + layoutSettings.minimumInteritemSpacing, y: contentHeight + lineInterSpace, width: itemSize.width, height: itemSize.height)
                
                attributes.zIndex = zIndex
                contentHeight = attributes.frame.maxY
                cache[Item.cell]?[cellIndexPath] = attributes
                zIndex += 1
            }
        }
    }
    
    
    /*To account for device rotations, we should definitely dump the cache*/
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true
    }
    
    
    private func prepareItem(size: CGSize, type: Item, attributes: CustomLayoutAttributes){
        guard size != CGSize.zero else {return}
        
        attributes.initOrigin = CGPoint(x: 0, y: contentHeight)
        attributes.frame = CGRect(origin: attributes.initOrigin, size: size)
        
        attributes.zIndex = zIndex
        zIndex += 1
        //What does this do?
        contentHeight = attributes.frame.maxY
        
        cache[type]?[attributes.indexPath] = attributes
    }
    
    private func prepareCache(){
        cache.removeAll(keepingCapacity: true)
        cache[.header] = [IndexPath: CustomLayoutAttributes]()
        cache[.cell] = [IndexPath: CustomLayoutAttributes]()
        cache[.menu] = [IndexPath: CustomLayoutAttributes]()
    }
    
   
}


