//
//  ImageTileSequence.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

struct ImageTileSequence: Sequence {
    let tileSize: CGSize
    let imageSize: CGSize
    
    let count: Int
    let numberOfTiles: Int
    
    init(tileSize: CGSize, imageSize: CGSize) {
        self.tileSize = tileSize
        self.imageSize = imageSize
        self.count = Int(imageSize.width / tileSize.width) * Int(imageSize.height / tileSize.height)
        self.numberOfTiles = Int(sqrt(Double(count)))
    }

    func makeIterator() -> ImageTileIterator {
        return ImageTileIterator(tileSize: tileSize, imageSize: imageSize)
    }
}

struct ImageTileIterator: IteratorProtocol {
    
    typealias Element = CGRect
    
    private(set) var current: CGPoint?
    let tileSize: CGSize
    let imageSize: CGSize
    
    init(tileSize: CGSize, imageSize: CGSize) {
        self.tileSize = tileSize
        self.imageSize = imageSize
    }
    
    mutating func next() -> CGRect? {
        guard let existingCurrent = current else {
            current = CGPoint.zero
            return CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
        }
        
        // TODO: WE have a rounding error because. This is solved with the "-1"s. We can do better.
        if existingCurrent.x + tileSize.width >= imageSize.width - 1 {
            if existingCurrent.y + tileSize.height >= imageSize.height - 1 {
                return nil
            }
            
            current = CGPoint(x: 0, y: existingCurrent.y + tileSize.height)
            return CGRect(x: 0, y: existingCurrent.y + tileSize.height, width: tileSize.width, height: tileSize.height)
        } else {
            current = CGPoint(x: existingCurrent.x + tileSize.width, y: existingCurrent.y)
            return CGRect(x: existingCurrent.x + tileSize.width, y: existingCurrent.y, width: tileSize.width, height: tileSize.height)
        }
    }

}
