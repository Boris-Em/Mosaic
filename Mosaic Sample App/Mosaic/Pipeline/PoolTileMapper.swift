//
//  ok.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/16/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit
import CoreGraphics

/// Maps images from the pool to each tile on the mosaic image.
final class PoolTileMapper {
    
    private let poolManager: ImagePoolManager
    private let resizedImageManager = ResizedImageManager()
    
    init(poolManager: ImagePoolManager) {
        self.poolManager = poolManager
    }
    
    func imagePositions(for sequence: ImageTileSequence, of averageColors: [UInt16]) -> [ImagePositionValuePair] {
        
        var tileImagePositions = [ImagePositionValuePair]()
        
        for (index, frame) in sequence.enumerated() {
            let red = averageColors[index * 4]
            let green = averageColors[index * 4 + 1]
            let blue = averageColors[index * 4 + 2]
            let alpha = averageColors[index * 4 + 3]
            let averageColor = UIColor(r: CGFloat(red / 255), g: CGFloat(green / 255), b: CGFloat(blue / 255), a: CGFloat(alpha))
            
            let closestTileImage = poolManager.closestImage(from: averageColor)
            let closestTileResizedImage = resizedImageManager.resizedImage(for: closestTileImage, size: sequence.tileSize)
            let imagePositionMap = ImagePositionValuePair(image: closestTileResizedImage, position: frame.origin)
            tileImagePositions.append(imagePositionMap)
        }
        
        return tileImagePositions
    }
    
}
