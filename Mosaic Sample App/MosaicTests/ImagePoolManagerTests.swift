//
//  ImagePoolManagerTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/21/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class ImagePoolManagerTests: XCTestCase {

    static let redImage = UIImage(named: "RedRectangle_50x50.jpg")!
    static let greenImage = UIImage(named: "GreenRectangle_50x50.jpg")!
    static let blueImage = UIImage(named: "BlueRectangle_50x50.jpg")!
    static let lightGreenImage = UIImage(named: "LightGreenRectangle_50x50.jpg")!
    static let blackImage = UIImage(named: "BlackRectangle_50x50.jpg")!
    static let whiteImage = UIImage(named: "WhiteRectangle_50x50.jpg")!
    
    private let sut = ImagePoolManager(images: [ImagePoolManagerTests.redImage, ImagePoolManagerTests.greenImage, ImagePoolManagerTests.blueImage, ImagePoolManagerTests.lightGreenImage, ImagePoolManagerTests.blackImage, ImagePoolManagerTests.whiteImage])
    
    func testRed() {
        let red = UIColor.red
        let image = sut.closestImage(from: red)
        XCTAssertEqual(image, ImagePoolManagerTests.redImage)
    }
    
    func testGreen() {
        let green = UIColor.green
        let image = sut.closestImage(from: green)
        XCTAssertEqual(image, ImagePoolManagerTests.greenImage)
    }
    
    func testBlue() {
        let blue = UIColor.blue
        let image = sut.closestImage(from: blue)
        XCTAssertEqual(image, ImagePoolManagerTests.blueImage)
    }
    
    func testLightGreen() {
        let lightGreen = UIColor(r: 55.0 / 255.0, g: 165.0 / 255.0, b: 74.0 / 255.0)
        let image = sut.closestImage(from: lightGreen)
        XCTAssertEqual(image, ImagePoolManagerTests.lightGreenImage)
    }
    
    func testBlack() {
        let black = UIColor.black
        let image = sut.closestImage(from: black)
        XCTAssertEqual(image, ImagePoolManagerTests.blackImage)
    }
    
    func testWhite() {
        let white = UIColor.white
        let image = sut.closestImage(from: white)
        XCTAssertEqual(image, ImagePoolManagerTests.whiteImage)
    }

}
