//
//  ColorsDistanceCalculatorTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 12/22/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class ColorsDistanceCalculatorTests: XCTestCase {

    func testRandomColorDistance() {
        let colorsDistanceCalculator = ColorsDistanceCalculator()
        
        let referenceColor = UIColor.blue
        let colorsToCompare = [
            UIColor.blue,
            UIColor.green,
            UIColor.yellow
            ].flatMap { (color) -> [UInt16] in
                color.rgba
        }
        
        let distances = colorsDistanceCalculator.execute(with: referenceColor, colorsToCompare: colorsToCompare)
        XCTAssertEqual(distances.count, colorsToCompare.count / 4)
        
        let blueBlueDistance = distances[0]
        let blueGreenDistance = distances[1]
        let blueYellowDistance = distances[2]
        
        XCTAssertEqual(blueBlueDistance, 0)
        
        XCTAssertGreaterThanOrEqual(blueGreenDistance, 99)
        XCTAssertLessThanOrEqual(blueGreenDistance, 101)
        
        XCTAssertGreaterThanOrEqual(blueYellowDistance, 60)
        XCTAssertLessThanOrEqual(blueYellowDistance, 62)
    }
    
    func testGrayColorDistance() {
        let colorsDistanceCalculator = ColorsDistanceCalculator()
        
        // Dark Gray
        let referenceColor = UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
        
        let colorsToCompare = [
            // Redish
            UIColor(red: 174.0 / 255.0, green: 74.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0),
            ].flatMap { (color) -> [UInt16] in
                color.rgba
        }
        
        let distances = colorsDistanceCalculator.execute(with: referenceColor, colorsToCompare: colorsToCompare)
        XCTAssertEqual(distances.count, colorsToCompare.count / 4)
        
        let grayRedishDistance = distances[0]
        XCTAssertGreaterThanOrEqual(grayRedishDistance, 60)
        XCTAssertLessThanOrEqual(grayRedishDistance, 62)
    }
    
}
