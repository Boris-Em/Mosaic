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
        let sequence = ImageTileSequence(numberOfTiles: 2, imageSize: imageSize)
        XCTAssertEqual(sequence.count, sequence.computeCount())
        
        for (index, rect) in sequence.enumerated() {
            if index == 0 {
                XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: sequence.tileSize.width, height: sequence.tileSize.height))
            } else if index == 1 {
                XCTAssertEqual(rect, CGRect(x: sequence.tileSize.width, y: 0, width: sequence.tileSize.width, height: sequence.tileSize.height))
            } else if index == 2 {
                XCTAssertEqual(rect, CGRect(x: 0, y: sequence.tileSize.height, width: sequence.tileSize.width, height: sequence.tileSize.height))
            } else if index == 3 {
                XCTAssertEqual(rect, CGRect(x: sequence.tileSize.width, y: sequence.tileSize.height, width: sequence.tileSize.width, height: sequence.tileSize.height))
            } else {
                XCTFail("There should only be 4 elements in the sequence.")
            }
        }
    }
    
    func testCountComplex() {
        let imageSize = CGSize(width: 3024, height: 4032)
        let sequence = ImageTileSequence(numberOfTiles: 50, imageSize: imageSize)
        XCTAssertEqual(sequence.count, sequence.computeCount())
    }
            
}

extension Sequence {
    
    func computeCount() -> Int {
        let count = reduce(0) { (result, _) -> Int in
            result + 1
        }
        
        return count
    }
    
}
