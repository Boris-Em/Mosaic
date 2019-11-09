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
    
    static let minImageCount = 5
        
    let images: [UIImage]
        
    private(set) var textures = [MTLTexture]()
    
    /// The average color for each image.
    /// Each color is reprensented by 4 elements: RGBA.
    private(set) var colors = [UInt16]()
    
    private lazy var device: MTLDevice = {
        return MTLCreateSystemDefaultDevice()!
    }()
    
    init(images: [UIImage]) {
        guard images.count >= ImagePoolManager.minImageCount else {
            fatalError("The `ImagePoolManager` should be initialized with at least \(ImagePoolManager.minImageCount) images.")
        }
        
        self.images = images
    }
    
    func preHeat(withTileSize tileSize: CGSize?) {
        _ = device
        
        if colors.isEmpty {
            colors = ImagePoolManager.generateImagePool(for: images)
        }
    
        if let tileSize = tileSize, textures.isEmpty {
            self.textures = generateTextures(for: images, tileSize: tileSize)
        }
    }
    
    /// Returns the colors for each image in an array where each element is RGBA.
    private static func generateImagePool(for images: [UIImage]) -> [UInt16] {
        let colors = images.flatMap { (image) -> [UInt16] in
            imageColorMap(for: image)
        }
        
        return colors
    }
    
    private static func imageColorMap(for image: UIImage) -> [UInt16] {
        let averageImageFinder = AverageColorFinder(image: image, canResizeImage: true)
        guard let averageColor = averageImageFinder.computeAverageColor() else {
            fatalError("Could not get average color.")
        }
        
        let colors = [
            UInt16(averageColor.red * 255.0),
            UInt16(averageColor.green * 255.0),
            UInt16(averageColor.blue * 255.0),
            UInt16(averageColor.alpha)
        ]
        
        return colors
    }
    
    private func generateTextures(for images: [UIImage], tileSize: CGSize) -> [MTLTexture] {
        let textures = images.map { (image) -> MTLTexture in
            let resizedImage = image.resize(to: tileSize)!
            let cgResizedImage = resizedImage.cgImage!
            
            let textureLoader = MTKTextureLoader(device: device)
            let texture = try! textureLoader.newTexture(cgImage: cgResizedImage, options: [MTKTextureLoader.Option.SRGB: 1, MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.topLeft])
            
            return texture
        }
        
        return textures
    }
    
}
