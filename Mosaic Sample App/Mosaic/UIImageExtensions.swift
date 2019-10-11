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
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
