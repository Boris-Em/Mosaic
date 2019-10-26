//
//  TileRects.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

/// Simple wrapper arround an array of `CGRect` describing the frame of all of the tiles.
struct TileRects {
    
    let rects: [CGRect]
    
    let tileSize: CGSize
    let imageSize: CGSize
    let numberOfTiles: Int
    
    var count: Int {
        return rects.count
    }
    
    init(numberOfTiles: Int, imageSize: CGSize) {
        self.imageSize = imageSize
        self.numberOfTiles = numberOfTiles

        self.tileSize = TileRects.tileSize(for: imageSize, numberOfTiles: numberOfTiles)
        let count = numberOfTiles * numberOfTiles
        
        self.rects = TileRects.generateRects(for: count, numberOfTiles, tileSize)
    }
    
    private static func tileSize(for imageSize: CGSize, numberOfTiles: Int) -> CGSize {
        let tileSize = CGSize(width: imageSize.width / CGFloat(numberOfTiles), height: imageSize.height / CGFloat(numberOfTiles))
        return tileSize
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
