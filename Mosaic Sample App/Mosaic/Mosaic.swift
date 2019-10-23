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
    private static let numberOfTiles: Int = 30
    
    private let imagePositionMapper: PoolTileMapper
    
    // MARK: Public Functions
    
    public init(imagePool: [UIImage]) throws {
        guard imagePool.count > 3 else {
            let error = NSError()
            throw error
        }
        
        let poolManager = ImagePoolManager(images: imagePool)
        self.imagePositionMapper = PoolTileMapper(poolManager: poolManager)
    }
    
    public func generateMosaic(for texture: MTLTexture) -> UIImage? {
        let imageSize = CGSize(width: texture.width, height: texture.height)
        let imageSequence = ImageTileSequence(numberOfTiles: Mosaic.numberOfTiles, imageSize: imageSize)
        let averageZoneColorFinder = AverageZoneColorFinder(texture: texture, imageSequence: imageSequence)
        
        return mosaic(for: imageSize, with: imageSequence, averageZoneColorFinder: averageZoneColorFinder)
    }
    
    public func generateMosaic(for image: CGImage) -> UIImage? {
        let imageSize = CGSize(width: image.width, height: image.height)
        let imageSequence = ImageTileSequence(numberOfTiles: Mosaic.numberOfTiles, imageSize: imageSize)
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        
        return mosaic(for: imageSize, with: imageSequence, averageZoneColorFinder: averageZoneColorFinder)
    }
    
    public func preHeat() {
        // TODO: Trigger the metal device.
    }
    
    // MARK: - Helpers
    
    private func mosaic(for imageSize: CGSize, with imageSequence: ImageTileSequence, averageZoneColorFinder: AverageZoneColorFinder) -> UIImage? {
        let averageColors = averageZoneColorFinder.find()
        
        let tileImagePositions = imagePositionMapper.imagePositions(for: imageSequence, of: averageColors)
        let mosaicImage = ImageStitcher.stitch(images: tileImagePositions, to: imageSize)

        return mosaicImage
    }
    
}

struct ImagePositionValuePair {
    
    let image: UIImage
    let position: CGPoint
    
}
