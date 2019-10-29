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
    
    func testOneImage() {
        let sut = ImagePoolManager(images: [ImagePoolManagerTests.redImage, ImagePoolManagerTests.greenImage, ImagePoolManagerTests.blueImage, ImagePoolManagerTests.lightGreenImage, ImagePoolManagerTests.blackImage, ImagePoolManagerTests.whiteImage])
        sut.preHeat()
        
        XCTAssertEqual(sut.colors, [
            254, 0, 0, 1,
            0, 255, 1, 1,
            0, 0, 254, 1,
            55, 165, 74, 1,
            0, 0, 0, 1,
            255, 255, 255, 1
        ])
    }
    
    func testImageCount() {
        let images = [ImagePoolManagerTests.redImage, ImagePoolManagerTests.greenImage, ImagePoolManagerTests.blueImage, ImagePoolManagerTests.lightGreenImage, ImagePoolManagerTests.blackImage, ImagePoolManagerTests.whiteImage]
        let sut = ImagePoolManager(images: images)
        sut.preHeat()
        
        XCTAssertEqual(sut.images.count, images.count)
    }
    
}
