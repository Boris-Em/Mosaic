//
//  ColorOverlayImageFilterTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 12/23/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class ColorOverlayImageFilterTests: XCTestCase {

    /// This test is mostly meant to be used visually.
    func testOverlay() {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "Test_image_1.jpg", in: bundle, compatibleWith: nil)!
        let overlayImage = ColorOverlayImageFilter.image(from: image, with: UIColor.green)
    }

}
