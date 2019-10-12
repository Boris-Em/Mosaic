//
//  AverageColorFinder.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

class AverageColorFinder {
    
    private let image: UIImage
    private var ciImage: CIImage
    
    init(image: UIImage, canResizeImage: Bool = false) {
        var newImage = image
        
        if canResizeImage && image.size.width > 300 {
            newImage = image.resize(to: CGSize(width: 300, height: 300))!
        }
        
        self.image = newImage
        self.ciImage = CIImage(image: newImage)!
    }
    
    /// Returns the average color on the image.
    func computeAverageColor() -> UIColor? {
        return computeAverageColor(for: CGRect(x: 0, y: 0, width: image.size.width * image.scale, height: image.size.height * image.scale))
    }
    
    func computeAverageColor(for region: CGRect) -> UIColor? {
        // TODO: Something is going on here where we need to invert the Y axis. Need investigation
        let regionExtent = CIVector(x: region.origin.x, y: image.size.height - region.origin.y - region.size.height, z: region.size.width, w: region.size.height)
        let filterName = "CIAreaAverage"
        let parameters = [
            kCIInputImageKey: ciImage,
            kCIInputExtentKey: regionExtent
        ]
        
        guard let filter = CIFilter(name: filterName, parameters: parameters) else {
            assertionFailure("Could not create the \(filterName) filter.")
            return nil
        }
        
        // The filter returns a single-pixel image that contains the average color for the region of interest.
        guard let filteredImage = filter.outputImage else {
            assertionFailure("Something went wrong when processing the image with the \(filterName) filter.")
            return nil
        }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        UIImage.ciContext.render(filteredImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
                
        let color = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
        
        return color
    }
    
}
