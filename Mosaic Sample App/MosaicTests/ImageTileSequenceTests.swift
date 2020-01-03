//
//  ImageTileSequenceTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/12/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class ImageTileSequenceTests: XCTestCase {
    
    func testCount() {
        let imageSize = CGSize(width: 100, height: 100)
        let numberOfTiles = 2
        
        let tiles = Tiles(numberOfTiles: numberOfTiles, imageSize: imageSize)
                
        for (index, rect) in tiles.frames.enumerated() {
            if index == 0 {
                XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else if index == 1 {
                XCTAssertEqual(rect, CGRect(x: tiles.tileSize.width, y: 0, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else if index == 2 {
                XCTAssertEqual(rect, CGRect(x: 0, y: tiles.tileSize.height, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else if index == 3 {
                XCTAssertEqual(rect, CGRect(x: tiles.tileSize.width, y: tiles.tileSize.height, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else {
                XCTFail("There should only be 4 elements in the sequence.")
            }
        }
    }
    
    func testCountClose() {
        let imageSize = CGSize(width: 1.5, height: 1.5)
        let numberOfTiles = 2
        
        let tiles = Tiles(numberOfTiles: numberOfTiles, imageSize: imageSize)
                
        for (index, rect) in tiles.frames.enumerated() {
            if index == 0 {
                XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else if index == 1 {
                XCTAssertEqual(rect, CGRect(x: tiles.tileSize.width, y: 0, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else if index == 2 {
                XCTAssertEqual(rect, CGRect(x: 0, y: tiles.tileSize.height, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else if index == 3 {
                XCTAssertEqual(rect, CGRect(x: tiles.tileSize.width, y: tiles.tileSize.height, width: tiles.tileSize.width, height: tiles.tileSize.height))
            } else {
                XCTFail("There should only be 4 elements in the sequence.")
            }
        }
    }
            
}
