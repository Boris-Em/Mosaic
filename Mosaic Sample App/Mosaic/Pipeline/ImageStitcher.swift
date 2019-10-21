//
//  ImageStitcher.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

class ImageStitcher {
    
    static func stitch(images: [ImagePositionValuePair], to size: CGSize) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        images.forEach { (imagePosition) in
            imagePosition.image.draw(at: imagePosition.position)
        }
        
        let sticthedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return sticthedImage
    }

}
