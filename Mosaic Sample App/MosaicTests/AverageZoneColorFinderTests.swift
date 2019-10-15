//
//  AverageZoneColorFinderTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/15/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class AverageZoneColorFinderTests: XCTestCase {

    func testAllRed() {
        let image = UIImage(named: "RedRectangle_50x50.jpg")!
        
        let numberOfTiles: CGFloat = 10
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let tileSize = CGSize(width: imageSize.width / numberOfTiles, height: imageSize.height / numberOfTiles)
        let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        let colors = averageZoneColorFinder.find()
        
        assertAll(red: 255, green: 0, blue: 0, colors: colors)
    }
    
    func testAllGreen() {
        let image = UIImage(named: "GreenRectangle_50x50.jpg")!
        
        let numberOfTiles: CGFloat = 10
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let tileSize = CGSize(width: imageSize.width / numberOfTiles, height: imageSize.height / numberOfTiles)
        let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        let colors = averageZoneColorFinder.find()
        
        assertAll(red: 0, green: 255, blue: 0, colors: colors)
    }
    
    func testAllBlue() {
        let image = UIImage(named: "BlueRectangle_50x50.jpg")!
        
        let numberOfTiles: CGFloat = 50
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let tileSize = CGSize(width: imageSize.width / numberOfTiles, height: imageSize.height / numberOfTiles)
        let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        let colors = averageZoneColorFinder.find()
        
        assertAll(red: 0, green: 0, blue: 255, colors: colors)
    }

}

extension AverageZoneColorFinderTests {
    
    /// Ensures that all of the pixels in the colors array are of the passed in color.
    func assertAll(red: UInt16, green: UInt16, blue: UInt16, colors: [UInt16]) {
        for index in stride(from: 0, to: colors.count, by: 4) {
            let actualRed = colors[index]
            let actualGreen = colors[index + 1]
            let actualBlue = colors[index + 2]
            
            let tolerence: UInt16 = 5
            
            let minRed = red >= tolerence ? red - tolerence : 0
            let maxRed = red <= tolerence ? red + tolerence : 255
            
            let minGreen = green >= tolerence ? green - tolerence : 0
            let maxGreen = green <= tolerence ? green + tolerence : 255
            
            let minBlue = blue >= tolerence ? blue - tolerence : 0
            let maxBlue = blue <= tolerence ? blue + tolerence : 255
            
            XCTAssertGreaterThanOrEqual(actualRed, minRed)
            XCTAssertLessThanOrEqual(actualRed, maxRed)
            
            XCTAssertGreaterThanOrEqual(actualGreen, minGreen)
            XCTAssertLessThanOrEqual(actualGreen, maxGreen)
            
            XCTAssertGreaterThanOrEqual(actualBlue, minBlue)
            XCTAssertLessThanOrEqual(actualBlue, maxBlue)
        }
        
    }
    
}
