//
//  ImagePoolManager.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit
import MetalKit

/// A simple object responsible for managing a pool of images and their average colors.
/// Those images are the ones used to create the mosaic.
final class ImagePoolManager {
        
    private(set) var images: [UIImage]
    private var shouldCheat: Bool
        
    private(set) var textures = [MTLTexture]()
    
    /// The average color for each image.
    /// Each color is reprensented by 4 elements: RGBA.
    private(set) var colors = [UInt16]()
    
    init(images: [UIImage], shouldCheat: Bool) {
        self.images = images
        self.shouldCheat = shouldCheat
    }
    
    func preHeat(withTileSize tileSize: CGSize?) {
        if colors.isEmpty {
            colors = ImagePoolManager.generateImagePool(for: images, shouldCheat: shouldCheat)
        }
        
        
        if shouldCheat {
            defer {
                shouldCheat = false
            }
            
            let cheats = ImagePoolCheatGenerator.generateCheats(for: colors, images: images)
            let cheatColors = cheats.flatMap { (cheat) -> [UInt16] in
                cheat.averageColor
            }
            let cheatImages = cheats.map { (cheat) -> UIImage in
                cheat.image
            }
            
            colors = colors + cheatColors
            images = images + cheatImages
        }
    
        if let tileSize = tileSize, textures.isEmpty {
            self.textures = generateTextures(for: images, tileSize: tileSize)
        }
    }
    
    /// Returns the colors for each image in an array where each element is RGBA.
    private static func generateImagePool(for images: [UIImage], shouldCheat: Bool) -> [UInt16] {
        let colors = images.flatMap { (image) -> [UInt16] in
            averageColor(for: image)
        }
        
        return colors
    }
    
    private static func averageColor(for image: UIImage) -> [UInt16] {
        let averageImageFinder = AverageColorFinder(image: image, canResizeImage: true)
        guard let averageColor = averageImageFinder.computeAverageColor() else {
            fatalError("Could not get average color.")
        }
        
        return averageColor.rgba
    }
    
    private func generateTextures(for images: [UIImage], tileSize: CGSize) -> [MTLTexture] {
        let textures = images.map { (image) -> MTLTexture in
            let resizedImage = image.resize(to: tileSize)!
            let cgResizedImage = resizedImage.cgImage!
            
            let textureLoader = MTKTextureLoader(device: MetalResourceManager.shared.device)
            let texture = try! textureLoader.newTexture(cgImage: cgResizedImage, options: [MTKTextureLoader.Option.SRGB: 1, MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.topLeft])
            
            return texture
        }
        
        return textures
    }
    
}
