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
    
    init(tileSize: CGSize, imageSize: CGSize) {
        self.tileSize = tileSize
        self.imageSize = imageSize
        self.count = Int(imageSize.width / tileSize.width) * Int(imageSize.height / tileSize.height)
    }

    func makeIterator() -> ImageTileIterator {
        return ImageTileIterator(tileSize: tileSize, imageSize: imageSize)
    }
}

struct ImageTileIterator: IteratorProtocol {
    
    typealias Element = CGRect
    
    private(set) var current = CGPoint.zero
    let tileSize: CGSize
    let imageSize: CGSize
    
    init(tileSize: CGSize, imageSize: CGSize) {
        self.tileSize = tileSize
        self.imageSize = imageSize
    }
    
    mutating func next() -> CGRect? {
        // TODO: WE have a rounding error because. This is solved with the "-1"s. We can do better.
        if current.x + tileSize.width >= imageSize.width - 1 {
            if current.y + tileSize.height >= imageSize.height - 1 {
                return nil
            }
            
            let realCurrent = current
            current = CGPoint(x: 0, y: current.y + tileSize.height)
            return CGRect(x: 0, y: realCurrent.y + tileSize.height, width: tileSize.width, height: tileSize.height)
        } else {
            let realCurrent = current
            current = CGPoint(x: current.x + tileSize.width, y: current.y)
            return CGRect(x: realCurrent.x + tileSize.width, y: realCurrent.y, width: tileSize.width, height: tileSize.height)
        }
    }

}
