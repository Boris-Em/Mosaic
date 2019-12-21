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
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "RedRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 10
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 255, green: 0, blue: 0, colors: colors)
    }
    
    func testAllGreen() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "GreenRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 10
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 0, green: 255, blue: 0, colors: colors)
    }
    
    func testAllLightGreen() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "LightGreenRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 10
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 55, green: 165, blue: 63, colors: colors)
    }
    
    func testAllBlue() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "BlueRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 50
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 0, green: 0, blue: 255, colors: colors)
    }
    
    func testAllBlack() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "BlackRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 50
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 0, green: 0, blue: 0, colors: colors)
    }
    
    func testAllWhite() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "WhiteRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 50
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 255, green: 255, blue: 255, colors: colors)
    }

    func testAllGray() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "GrayRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 50
        
        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        assertAll(red: 150, green: 150, blue: 150, colors: colors)
    }
    
    func testMulti() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "MultiRectangle_10x10.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 2

        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)
        
        // Red
        let topLeftRed = colors[0]
        let topLeftGreen = colors[1]
        let topLeftBlue = colors[2]
        
        XCTAssertGreaterThanOrEqual(topLeftRed, 250)
        XCTAssertLessThanOrEqual(topLeftRed, 255)
        
        XCTAssertLessThanOrEqual(topLeftGreen, 5)
        XCTAssertLessThanOrEqual(topLeftBlue, 5)
        
        // Green
        let topRightRed = colors[4]
        let topRightGreen = colors[5]
        let topRightBlue = colors[6]
        
        XCTAssertLessThanOrEqual(topRightRed, 5)
        
        XCTAssertGreaterThanOrEqual(topRightGreen, 250)
        XCTAssertLessThanOrEqual(topRightGreen, 255)
        
        XCTAssertLessThanOrEqual(topRightBlue, 5)
        
        // Blue
        let bottomLeftRed = colors[8]
        let bottomLeftGreen = colors[9]
        let bottomLeftBlue = colors[10]
        
        XCTAssertLessThanOrEqual(bottomLeftRed, 5)
        
        XCTAssertLessThanOrEqual(bottomLeftGreen, 5)
        
        XCTAssertGreaterThanOrEqual(bottomLeftBlue, 250)
        XCTAssertLessThanOrEqual(bottomLeftBlue, 255)
        
        // Purple
        let bottomRightRed = colors[12]
        let bottomRightGreen = colors[13]
        let bottomRightBlue = colors[14]
        
        XCTAssertGreaterThanOrEqual(bottomRightRed, 197)
        XCTAssertLessThanOrEqual(bottomRightRed, 200)

        XCTAssertGreaterThanOrEqual(bottomRightGreen, 60)
        XCTAssertLessThanOrEqual(bottomRightGreen, 62)
        
        XCTAssertGreaterThanOrEqual(bottomRightBlue, 250)
        XCTAssertLessThanOrEqual(bottomRightBlue, 255)
    }
    
    /// This test is made to ensure that the average color is working properly.
    /// It's mostly used for debug puposes.
    /// It should be verified "by hand" by comparing the original image to the one generated with zone colors.
    func testRealCase() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "Test_image_1.jpg", in: bundle, compatibleWith: nil)!.cgImage!
        
        let numberOfTiles = 50

        let imageSize = CGSize(width: image.width, height: image.height)
        let tileRects = TileRects(numberOfTiles: numberOfTiles, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: image, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let data = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        data.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)

        _ = self.image(from: colors, tileRects: tileRects)
    }

}

extension AverageZoneColorFinderTests {
    
    /// Gets rects and average colors, and draw those colors on the given rects.
    func image(from colors: [UInt16], tileRects: TileRects) -> UIImage {
        var uiColors = [UIColor]()
        
        for index in 0..<colors.count / 4  {
            let actualIndex = index * 4
            let color = UIColor(red: CGFloat(colors[actualIndex]) / 255.0, green: CGFloat(colors[actualIndex + 1]) / 255.0, blue: CGFloat(colors[actualIndex + 2]) / 255.0, alpha: 1.0)
            uiColors.append(color)
        }
        
        UIGraphicsBeginImageContextWithOptions(tileRects.imageSize, true, 0.0)
        
        for (index, rect) in tileRects.rects.enumerated() {
            let color = uiColors[index]
            color.setFill()
            UIRectFill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        return image!
    }
    
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
