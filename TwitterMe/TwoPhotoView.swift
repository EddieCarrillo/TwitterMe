//
//  TwoPhotoView.swift
//  MediaDisplay
//
//  Created by Eduardo Carrillo on 1/3/18.
//  Copyright © 2018 Eduardo Carrillo. All rights reserved.
//

import UIKit

class TwoPhotoView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    var imageTapped: ((Int, [UIImage])->())?
    
    var images: [UIImage] {
        get{
            var unwrappedPhotos: [UIImage] = []
            
            let wrapped: [UIImage?] = [firstImageView.image, secondImageView.image]
            
            for wrapped in wrapped {
                if let unwrappedPhoto = wrapped {
                    unwrappedPhotos.append(unwrappedPhoto)
                }
            }
            
            return unwrappedPhotos
        }
    }
    
    
    
    var firstPhoto: UIImage? {
        didSet{
            guard let firstImage = firstPhoto else {
                print("Image is nil")
                return
            }
            
            firstImageView.image = firstImage
        }
    }
    
    var secondPhoto: UIImage? {
        didSet{
            guard let secondImage = firstPhoto else {
                print("Image is nil")
                return
            }
            
            secondImageView.image = secondImage
        }
    }
    
    
    
    var firstURL: URL? {
        didSet{
            guard let firstURL = firstURL else {
                print("Could not extract first URL")
                return
            }
            self.firstImageView.setImageWith(firstURL)
        }
    }
    
    
    var secondURL: URL? {
        didSet{
            guard let secondURL = secondURL else {
                print("Could not extract first URL")
                return
            }
            self.secondImageView.setImageWith(secondURL)
        }
    }
    
  
    
    func firstImageTapped(){
        imageTapped?(0, images)
        
    }
    
    func secondImageTapped(){
        imageTapped?(1, images)

    }
    

    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews(){
        let nib = UINib(nibName: "TwoPhotoView", bundle: nil)
        
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        //Make the corners more rounded
        self.layer.cornerRadius = 100.0
        
        
        firstImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstImageTapped)))
        secondImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondImageTapped)))
        
        
        addSubview(contentView)
        
    
    }
    
    

}
