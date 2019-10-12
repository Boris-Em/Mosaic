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
        let tileSize = CGSize(width: 50, height: 50)
        let imageSize = CGSize(width: 100, height: 100)
        let sequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        XCTAssertEqual(sequence.count, sequence.computeCount())
    }
    
    func testCountComplex() {
        let tileSize = CGSize(width: 60.48, height: 80.64)
        let imageSize = CGSize(width: 3024, height: 4032)
        let sequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        XCTAssertEqual(sequence.count, sequence.computeCount())
    }
            
}

extension Sequence {
    
    func computeCount() -> Int {
        let count = reduce(1) { (result, _) -> Int in
            result + 1
        }
        
        return count
    }
    
}
