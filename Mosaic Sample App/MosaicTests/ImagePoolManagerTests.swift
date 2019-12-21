//
//  swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/21/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class ImagePoolManagerTests: XCTestCase {
    
    private lazy var bundle: Bundle = {
        Bundle(for: type(of: self))
    }()

    private lazy var redImage: UIImage = {
        UIImage(named: "RedRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!
    }()
    private lazy var greenImage: UIImage = {
        UIImage(named: "GreenRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!
    }()
    private lazy var blueImage: UIImage = {
        UIImage(named: "BlueRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!
    }()
    private lazy var lightGreenImage: UIImage = {
        UIImage(named: "LightGreenRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!
    }()
    private lazy var blackImage: UIImage = {
        UIImage(named: "BlackRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!
    }()
    private lazy var whiteImage: UIImage = {
        UIImage(named: "WhiteRectangle_50x50.jpg", in: bundle, compatibleWith: nil)!
    }()
    
    func testOneImage() {
        let sut = ImagePoolManager(images: [redImage, greenImage, blueImage, lightGreenImage, blackImage, whiteImage])
        sut.preHeat(withTileSize: nil)
        
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
        let images = [redImage, greenImage, blueImage, lightGreenImage, blackImage, whiteImage]
        let sut = ImagePoolManager(images: images)
        sut.preHeat(withTileSize: nil)
        
        XCTAssertEqual(sut.images.count, images.count)
    }
    
}
