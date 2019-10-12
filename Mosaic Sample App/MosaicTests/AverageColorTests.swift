//
//  AverageColorTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class AverageColorTests: XCTestCase {

    func testRedImage() {
        let image = UIImage(named: "RedRectangle.jpg")!
        let averageColorFinder = AverageColorFinder(image: image)
        let averageColor = averageColorFinder.computeAverageColor()
        
        var red: CGFloat = -1
        var green: CGFloat = -1
        var blue: CGFloat = -1
        
        averageColor?.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        XCTAssertGreaterThanOrEqual(red, 0.9)
        XCTAssertEqual(green, 0)
        XCTAssertEqual(blue, 0)
    }
    
    func testPerformance() {
        let image = UIImage(named: "Test_image_1.jpg")!
        let averageColorFinder = AverageColorFinder(image: image)

        measure {
            _ = averageColorFinder.computeAverageColor()
        }
    }
    
}
