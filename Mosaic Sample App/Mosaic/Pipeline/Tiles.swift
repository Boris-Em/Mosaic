//
//  Tiles.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

/// A data structure that keeps track of info around the tiles of a picture.
struct Tiles {
    
    let frames: [CGRect]
    
    let tileSize: CGSize
    let imageSize: CGSize
    let numberOfTiles: Int
    
    var count: Int {
        return frames.count
    }
    
    init(numberOfTiles: Int, imageSize: CGSize) {
        self.imageSize = Tiles.outputImageSize(for: imageSize, numberOfTiles: numberOfTiles)
        self.numberOfTiles = numberOfTiles

        self.tileSize = Tiles.tileSize(for: self.imageSize, numberOfTiles: numberOfTiles)
        let count = numberOfTiles * numberOfTiles
        
        self.frames = Tiles.generateRects(for: count, numberOfTiles, tileSize)
    }
    
    private static func tileSize(for imageSize: CGSize, numberOfTiles: Int) -> CGSize {
        let tileSize = CGSize(width: imageSize.width / CGFloat(numberOfTiles), height: imageSize.height / CGFloat(numberOfTiles))
        return tileSize
    }
    
    /// It's not always possible to output an image of the same size as the input image.
    /// This is because the number of tiles required doesn't always fit within the size of the image.
    /// For example, a 10x10 image, cannot fit 3 tiles of the same size.
    /// Instead we should create a 9x9 image.
    private static func outputImageSize(for inputImageSize: CGSize, numberOfTiles: Int) -> CGSize {
        let widthTilePixelCount = Int(inputImageSize.width) / numberOfTiles
        let heightTilePixelCount = Int(inputImageSize.height) / numberOfTiles
        
        let outputImageSize = CGSize(width: widthTilePixelCount * numberOfTiles, height: heightTilePixelCount * numberOfTiles)
        
        return outputImageSize
    }
    
    private static func generateRects(for count: Int, _ numberOfTiles: Int, _ tileSize: CGSize) -> [CGRect] {
        var rects = Array(repeating: CGRect.zero, count: count)
        
        for iteration in 0..<count {
            let x = CGFloat(iteration % numberOfTiles) * tileSize.width
            let y = CGFloat(iteration / numberOfTiles) * tileSize.height
            let width = tileSize.width
            let height = tileSize.height
            
            rects[iteration] = CGRect(x: x, y: y, width: width, height: height)
        }
        
        return rects
    }
    
}
