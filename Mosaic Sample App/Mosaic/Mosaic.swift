//
//  Mosaic.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

public final class Mosaic {
    
    /// The numbner of tiles in the mosaic per length (width & height).
    static let numberOfTiles: CGFloat = 50
    
    private let poolManager: ImagePoolManager
    private let resizedImageManager = ResizedImageManager()
    
    public init(imagePool: [UIImage]) throws {
        guard imagePool.count > 3 else {
            let error = NSError()
            throw error
        }
        
        poolManager = ImagePoolManager(images: imagePool)
    }
    
    public func generateMosaic(for image: UIImage) -> UIImage? {
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let tileSize = CGSize(width: imageSize.width / Mosaic.numberOfTiles, height: imageSize.height / Mosaic.numberOfTiles)
        
        let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
                
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        let averageColors = averageZoneColorFinder.find()
        
        var tileImagePositions = [ImagePositionMap]()
        
        for (index, frame) in imageSequence.enumerated() {
            let red = averageColors[index * 4]
            let green = averageColors[index * 4 + 1]
            let blue = averageColors[index * 4 + 2]
            let alpha = averageColors[index * 4 + 3]
            let averageColor = UIColor(r: CGFloat(red / 255), g: CGFloat(green / 255), b: CGFloat(blue / 255), a: CGFloat(alpha))
            
            let closestTileImage = poolManager.closestImage(from: averageColor)
            let closestTileResizedImage = resizedImageManager.resizedImage(for: closestTileImage, size: tileSize)
            let imagePositionMap = ImagePositionMap(image: closestTileResizedImage, position: frame.origin)
            tileImagePositions.append(imagePositionMap)
        }

        let mosaicImage = ImageStitcher.stitch(images: tileImagePositions, to: imageSize)

        return mosaicImage
    }
    
}

struct ImagePositionMap {
    
    let image: UIImage
    let position: CGPoint
    
}
