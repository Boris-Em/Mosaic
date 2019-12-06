//
//  Mosaic.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

public final class Mosaic {
    
    private var tileRects: TileRects?
    
    private let imagePositionMapper: PoolTileMapper
    private let averageZoneColorFinder = AverageZoneColorFinder()
    
    // MARK: - Public
    
    /// The numbner of tiles in the mosaic per length (width & height).
    let numberOfTiles: Int = 200
    
    public init(imagePool: [UIImage]) throws {
        guard imagePool.count > 3 && imagePool.count < 28 else {
            let error = NSError()
            throw error
        }
        
        let poolManager = ImagePoolManager(images: imagePool)
        self.imagePositionMapper = PoolTileMapper(poolManager: poolManager)
    }
    
    public func generateMosaic(for texture: MTLTexture) -> UIImage? {
        guard let texture: MTLTexture = generateMosaic(for: texture) else {
            return nil
        }
        
        let image = mosaicImage(from: texture)
        
        return image
    }
    
    public func generateMosaic(for image: CGImage) -> UIImage? {
        guard let texture: MTLTexture = generateMosaic(for: image) else {
            return nil
        }
        
        let image = mosaicImage(from: texture)
        
        return image
    }

    public func generateMosaic(for texture: MTLTexture) -> MTLTexture? {
        let imageSize = CGSize(width: texture.width, height: texture.height)

        guard let tileRects = tileRects else {
            generateTileRects(with: imageSize)
            return generateMosaic(for: texture)
        }

        let averageColors = averageZoneColorFinder.findAverageZoneColor(on: texture, with: tileRects)
        return mosaic(with: imageSize, tileRects, averageColors)
    }
    
    public func generateMosaic(for image: CGImage) -> MTLTexture? {
        let imageSize = CGSize(width: image.width, height: image.height)
        
        guard let tileRects = tileRects else {
            generateTileRects(with: imageSize)
            return generateMosaic(for: image)
        }

        let averageColors = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        return mosaic(with: imageSize, tileRects, averageColors)
    }
    
    /// Optionally prepares the `Mosaic` instance so that it can start doing its work as fast as possible.
    /// Call this function when you know that a mosaic could be generated, but the process hasn't started yet.
    /// @see `preHeat()`
    /// - Parameters:
    ///   - imageSize: The size of the image that will be transformed into a Mosaic.
    public func preHeat(withImageSize imageSize: CGSize? = nil) {
        if let imageSize = imageSize {
            generateTileRects(with: imageSize)
        }
        
        imagePositionMapper.preHeat(withTileSize: self.tileRects?.tileSize)
        averageZoneColorFinder.preHeat()
    }
    
    private func mosaic(with imageSize: CGSize, _ tileRects: TileRects, _ averageColors: MTLBuffer) -> MTLTexture? {

        let texturePositions = imagePositionMapper.match(tileRects, to: averageColors)
        let mosaicImage = ImageStitcher().stitch(texturePositions: texturePositions, to: imageSize, numberOfTiles: tileRects.numberOfTiles)

        return mosaicImage
    }
        
    // MARK: - Convenience
    
    private func mosaicImage(from texture: MTLTexture) -> UIImage {
        let kciOptions = [CIImageOption.colorSpace: CGColorSpaceCreateDeviceRGB(),
                          CIContextOption.outputPremultiplied: true,
                          CIContextOption.useSoftwareRenderer: false] as! [CIImageOption : Any]
        
        let ciImage = CIImage(mtlTexture: texture, options: kciOptions)!.oriented(CGImagePropertyOrientation.downMirrored)
        let uiImage = UIImage(ciImage: ciImage)

        return uiImage
    }
    
    private func generateTileRects(with imageSize: CGSize) {
        self.tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
    }
    
}
