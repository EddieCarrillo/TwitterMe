//
//  OnePhotoMedia.swift
//  MediaDisplay
//
//  Created by Eduardo Carrillo on 1/3/18.
//  Copyright © 2018 Eduardo Carrillo. All rights reserved.
//

import UIKit

class OnePhotoMedia: UIView {

    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    var imageTapped: ((Int, [UIImage])->())?
    
    var images: [UIImage] {
        get{
            if let photo = firstImageView.image {
                return [photo]
            }else{
                return []
           }
        }
    }
    
    
    
    
    
    
    var photo: UIImage?{
        didSet{
            self.firstImageView.image = photo
        }
    }
    
    
    var photoURL: URL?{
        didSet{
            guard let url = photoURL else {
                print("NO/BAD URL SET!")
                return
            }
            
            self.firstImageView.setImageWith(url)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    @objc func firstImageTapped(){
        imageTapped?(0, images)
    }
    
    
    func initSubviews(){
        let nib = UINib(nibName: "OnePhotoView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.frame = bounds
        contentView.clipsToBounds = true
        //Make the corners more rounded
        self.layer.cornerRadius = 5.0
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstImageTapped))
    firstImageView.addGestureRecognizer(firstTapGesture)
        
        addSubview(contentView)
    }
    

}
