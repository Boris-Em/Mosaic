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
        
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
                
        for (index, rect) in tileRects.rects.enumerated() {
            if index == 0 {
                XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else if index == 1 {
                XCTAssertEqual(rect, CGRect(x: tileRects.tileSize.width, y: 0, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else if index == 2 {
                XCTAssertEqual(rect, CGRect(x: 0, y: tileRects.tileSize.height, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else if index == 3 {
                XCTAssertEqual(rect, CGRect(x: tileRects.tileSize.width, y: tileRects.tileSize.height, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else {
                XCTFail("There should only be 4 elements in the sequence.")
            }
        }
    }
    
    func testCountClose() {
        let imageSize = CGSize(width: 1.5, height: 1.5)
        let numberOfTiles = 2
        
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
                
        for (index, rect) in tileRects.rects.enumerated() {
            if index == 0 {
                XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else if index == 1 {
                XCTAssertEqual(rect, CGRect(x: tileRects.tileSize.width, y: 0, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else if index == 2 {
                XCTAssertEqual(rect, CGRect(x: 0, y: tileRects.tileSize.height, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else if index == 3 {
                XCTAssertEqual(rect, CGRect(x: tileRects.tileSize.width, y: tileRects.tileSize.height, width: tileRects.tileSize.width, height: tileRects.tileSize.height))
            } else {
                XCTFail("There should only be 4 elements in the sequence.")
            }
        }
    }
            
}
