//
//  Mosaic.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

/// The `Mosaic` class is the entry point to generate beautiful photographic mosaics.
public final class Mosaic {
    
    /// Represents the different cheat modes.
    /// Cheat modes are here to help with image pools that don't have a wide variety of average colors.
    public enum CheatMode {
        
        /// `Mosaic` will attenpt to automatically determine if cheating is required or not.
        case automatic
        
        /// Enabled cheating. `Mosaic` will actively complete the image pool by generating new images close to the colors that are missing.
        case enabled
        
        /// Mosaic will use the image pool as is.
        case disabled
    }
    
    /// Defines errors specific to `Mosaic`.
    public enum MosaicError: Error {
        
        /// Too little or too many images were used for the image pool.
        case imagePoolCountError(count: Int)
        
        /// Something went wrong generating the photographic mosaic.
        case mosaicGenerationError
        
        var localizedDescription: String {
            switch self {
            case .imagePoolCountError (let count):
                return "The `imagePool` was initialized with \(count). It should be initialized with at least \(Mosaic.minImagePoolCount) and at most \(Mosaic.maxImagePoolCount) images."
            case .mosaicGenerationError:
                return "Could not generate photographic mosaic."
            }
        }
    }
    
    private var tiles: Tiles?
    private let imagePositionMapper: PoolTileMapper
    private let averageZoneColorFinder = AverageZoneColorFinder()
        
    /// The numbner of tiles in the mosaic per length (width & height).
    private let numberOfTiles: Int
    
    /// The minumum number of images that should be passed in at initialization via the `imagePool` parameter.
    static private let minImagePoolCount = 3
    
    /// The minumum number of images that should be passed in at initialization via the `imagePool` parameter.
    static private let maxImagePoolCount = 70
    
    /// The minumum number of images that should be passed in at initialization via the `imagePool` parameter in order not to auto-activate cheating.
    static private let minCheatImagePoolCount = 15
    
    // MARK: - Life Cycle
    
    /// Hello.
    /// - Parameters:
    ///    - imagePool: The images to use in order to generate the photographic mosaic.
    ///    - cheatMode: Determines if Mosaic should "cheat" to generate the photographic mosaic.
    ///       It can be hard to come up with a wide variety of images in the image pool. Enabling cheating, will ensure that all colors are represented.
    ///    - numberOfTiles: The number of tiles in the photographic mosaic per length (width & height).
    public init(imagePool: [UIImage], cheatMode: CheatMode = .automatic, numberOfTiles: Int = 75) throws {
        var shouldCheat = cheatMode == .enabled
        guard imagePool.count > Mosaic.minImagePoolCount && imagePool.count < Mosaic.maxImagePoolCount else {
            throw MosaicError.imagePoolCountError(count: imagePool.count)
        }
        
        if imagePool.count < Mosaic.minCheatImagePoolCount, cheatMode == .automatic {
            print("Not enough images. The cheat mode is activated.")
            shouldCheat = true
        }
        
        self.numberOfTiles = numberOfTiles
        let poolManager = ImagePoolManager(images: imagePool, shouldCheat: shouldCheat)
        self.imagePositionMapper = PoolTileMapper(poolManager: poolManager)
    }
    
    // MARK: - Public Functions
    // MARK: Mosaic Generation
    
    /// Generates a photographic mosaic from the passed in `MTLTexture` instance.
    /// - Parameters:
    ///   - texture: The image texture to generate the photographic mosaic from.
    /// - Returns: The photographic mosaic as a `UIImage` instance.
    public func generate(for texture: MTLTexture) throws -> UIImage {
        let texture: MTLTexture = generate(for: texture)
        
        do {
            let image = try texture.toImage()
            return image
        } catch {
            throw MosaicError.mosaicGenerationError
        }
    }
    
    /// Generates a photographic mosaic from the passed in `CGImage` instance.
    /// - Parameters:
    ///   - image: The image to generate the photographic mosaic from.
    /// - Returns: The photographic mosaic as a `UIImage` instance.
    public func generate(for image: CGImage) throws -> UIImage {
        let texture: MTLTexture = generate(for: image)
        do {
            let image = try texture.toImage()
            return image
        } catch {
            throw MosaicError.mosaicGenerationError
        }
    }

    /// Generates a photographic mosaic from the passed in `MTLTexture` instance.
    /// This function is the fastest way of generating the mosaic as it doesn't require any image conversions.
    /// - Parameters:
    ///   - texture: The image texture to generate the photographic mosaic from.
    /// - Returns: The photographic mosaic as a `MTKTexture` instance.
    public func generate(for texture: MTLTexture) -> MTLTexture {
        guard let tiles = tiles else {
            let imageSize = CGSize(width: texture.width, height: texture.height)
            self.tiles = Tiles(numberOfTiles: numberOfTiles, imageSize: imageSize)
            return generate(for: texture)
        }

        let averageColors = averageZoneColorFinder.findAverageZoneColor(on: texture, with: tiles)
        return mosaic(with: tiles, averageColors)
    }
    
    /// Generates a photographic mosaic from the passed in `CGImage` instance.
    /// - Parameters:
    ///   - image: The image to generate the photographic mosaic from.
    /// - Returns: The photographic mosaic as a `UIImage` instance.
    public func generate(for image: CGImage) -> MTLTexture {
        guard let tiles = tiles else {
            let imageSize = CGSize(width: image.width, height: image.height)
            self.tiles = Tiles(numberOfTiles: numberOfTiles, imageSize: imageSize)
            return generate(for: image)
        }

        let averageColors = averageZoneColorFinder.findAverageZoneColor(on: image, with: tiles)
        
        return mosaic(with: tiles, averageColors)
    }
    
    // MARK: Pre Heat
    
    /// Optionally prepares the `Mosaic` instance so that it can start doing its work as fast as possible.
    /// Call this function when you know that a mosaic could be generated, but the process hasn't started yet.
    /// - Parameters:
    ///   - imageSize: The size of the image that will be transformed into a Mosaic.
    public func preHeat(withImageSize imageSize: CGSize? = nil) {
        if let imageSize = imageSize {
            self.tiles = Tiles(numberOfTiles: numberOfTiles, imageSize: imageSize)
        }
        
        imagePositionMapper.preHeat(withTileSize: self.tiles?.tileSize)
        averageZoneColorFinder.preHeat()
    }
    
    // MARK: - Private Functions
    
    private func mosaic(with tiles: Tiles, _ averageColors: MTLBuffer) -> MTLTexture {
        let texturePositions = imagePositionMapper.match(tiles, to: averageColors)
        let mosaicImage = ImageStitcher().stitch(texturePositions: texturePositions, to: tiles.imageSize, numberOfTiles: tiles.numberOfTiles)

        return mosaicImage
    }
    
}
