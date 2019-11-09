//
//  UIImageExtensions.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let ciContext = CIContext(options: [.workingColorSpace: kCFNull as Any])
    
    /// Resizes the image to the passed in size.
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: size.height)))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
