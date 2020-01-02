//
//  TileRectsTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 1/2/20.
//  Copyright © 2020 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class TileRectsTests: XCTestCase {

    func testImageSizeSimple() {
        let imageSize = CGSize(width: 10.0, height: 10.0)
        let tileRect = TileRects(numberOfTiles: 9, imageSize: imageSize)
        let expectedImageSize = CGSize(width: 9.0, height: 9.0)
        
        XCTAssertEqual(tileRect.imageSize, expectedImageSize)
    }
    
    func testImageSizeCommon() {
        let imageSize = CGSize(width: 1280, height: 1024)
        let tileRect = TileRects(numberOfTiles: 70, imageSize: imageSize)
        let expectedImageSize = CGSize(width: 1260, height: 980)
        
        XCTAssertEqual(tileRect.imageSize, expectedImageSize)
    }
    
}
