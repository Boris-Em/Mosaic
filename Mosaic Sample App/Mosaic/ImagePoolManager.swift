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
    
    private var pool: [ImageColorMap]?
    private let images: [UIImage]
    
    init(images: [UIImage]) {
        guard images.count >= ImagePoolManager.minImageCount else {
            fatalError("The `ImagePoolManager` should be initialized with at least \(ImagePoolManager.minImageCount) images.")
        }
        
        self.images = images
    }
    
    func preHeat() {
        self.pool = ImagePoolManager.generateImagePool(for: images)
    }
    
    func closestImage(from color: UIColor) -> UIImage {
        guard let pool = pool, !pool.isEmpty else {
            preHeat()
            return closestImage(from: color)
        }
        
        var bestImageColorMap = pool.first!
        var bestScore = bestImageColorMap.averageColor.CIEDE2000(compare: color)
        
        pool.forEach { (imageColorMap) in
            let score = imageColorMap.averageColor.CIEDE2000(compare: color)
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
            fatalError("Could not get average color.")
        }
        
        return ImageColorMap(image: image, averageColor: averageColor)
    }
    
}
