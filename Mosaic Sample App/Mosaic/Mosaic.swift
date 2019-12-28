//
//  Mosaic.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

public final class Mosaic {
    
    public enum CheatMode {
        case automatic
        case enabled
        case disabled
    }
    
    enum MosaicError: Error {
        case imagePoolCountError(count: Int)
        
        var localizedDescription: String {
            switch self {
            case .imagePoolCountError (let count):
                return "The `imagePool` was initialized with \(count). It should be initialized with at least \(Mosaic.minImagePoolCount) and at most \(Mosaic.maxImagePoolCount) images."
            }
        }
    }
    
    private var tileRects: TileRects?
    
    private let imagePositionMapper: PoolTileMapper
    private let averageZoneColorFinder = AverageZoneColorFinder()
    
    // MARK: - Public
    
    /// The numbner of tiles in the mosaic per length (width & height).
    let numberOfTiles: Int = 70
    
    /// The minumum number of images that should be passed in at initialization via the `imagePool` parameter.
    static let minImagePoolCount = 3
    
    /// The minumum number of images that should be passed in at initialization via the `imagePool` parameter.
    static let maxImagePoolCount = 50
    
    /// The minumum number of images that should be passed in at initialization via the `imagePool` parameter, in order not to auto-activate cheating.
    static let minCheatImagePoolCount = 15
    
    public init(imagePool: [UIImage], cheatDecision: CheatMode = .automatic) throws {
        var shouldCheat = cheatDecision == .enabled
        guard imagePool.count > Mosaic.minImagePoolCount && imagePool.count < Mosaic.maxImagePoolCount else {
            throw MosaicError.imagePoolCountError(count: imagePool.count)
        }
        
        if imagePool.count < Mosaic.minCheatImagePoolCount, cheatDecision == .automatic {
            print("Not enough images. The cheat mode activated.")
            shouldCheat = true
        }
        
        let poolManager = ImagePoolManager(images: imagePool, shouldCheat: shouldCheat)
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
