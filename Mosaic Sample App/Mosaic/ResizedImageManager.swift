//
//  ResizedImageManager.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

class ResizedImageManager {
    
    private var cache: [UIImage : UIImage] = [UIImage : UIImage]()
    
    func resizedImage(for image: UIImage, size: CGSize) -> UIImage {
        if let cachedResizedImage = cache[image] {
            return cachedResizedImage
        }
        
        let resizedImage = image.resize(to: size)!
        cache[image] = resizedImage
        
        return resizedImage
    }
    
}
