//
//  ImagePoolManager.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

class ImagePoolManager {
    
    static let minImageCount = 5
        
    private struct ImageColorMap {
        let image: UIImage
        let averageColor: UIColor
    }
    
    private var pool: [ImageColorMap]
    
    init(images: [UIImage]) {
        guard images.count > ImagePoolManager.minImageCount else {
            fatalError("The `ImagePoolManager` should be initialized with at least 3 images.")
        }
        
        self.pool = ImagePoolManager.generateImagePool(for: images)
        
        guard pool.count > ImagePoolManager.minImageCount else {
            fatalError("Could not generate enough images for the pool.")
        }
    }
    
    func closestImage(from color: UIColor) -> UIImage {
        var bestImageColorMap = pool.first!
        var bestScore = bestImageColorMap.averageColor.CIEDE2000(compare: color)
        
        pool.forEach { (imageColorMap) in
            let score = imageColorMap.averageColor.CIE94(compare: color)
            if score < bestScore {
                bestImageColorMap = imageColorMap
                bestScore = score
            }
        }
        
        return bestImageColorMap.image
    }
    
    private static func generateImagePool(for images: [UIImage]) -> [ImageColorMap] {
        return images.compactMap { (image) -> ImageColorMap? in
            imagePool(for: image)
        }
    }
    
    private static func imagePool(for image: UIImage) -> ImageColorMap? {
        let averageImageFinder = AverageColorFinder(image: image, canResizeImage: true)
        guard let averageColor = averageImageFinder.computeAverageColor() else {
            assertionFailure("Could not get average color.")
            return nil
        }
        
        return ImageColorMap(image: image, averageColor: averageColor)
    }
    
}
