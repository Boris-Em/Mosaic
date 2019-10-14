//
//  AverageZoneColorFinderTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/12/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class AverageZoneColorFinderTests: XCTestCase {

    func test() {
        let image = UIImage(named: "MultiRectangle_2x2.jpg")!
        let numberOfTiles: CGFloat = 2
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let tileSize = CGSize(width: imageSize.width / numberOfTiles, height: imageSize.height / numberOfTiles)
        let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        averageZoneColorFinder.find()
    }

}
