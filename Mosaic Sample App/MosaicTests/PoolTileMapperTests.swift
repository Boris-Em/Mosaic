//
//  PoolTileMapperTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/21/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class PoolTileMapperTests: XCTestCase {
    
    static let redImage = UIImage(named: "RedRectangle_50x50.jpg")!
    static let greenImage = UIImage(named: "GreenRectangle_50x50.jpg")!
    static let blueImage = UIImage(named: "BlueRectangle_50x50.jpg")!
    static let lightGreenImage = UIImage(named: "LightGreenRectangle_50x50.jpg")!
    static let blackImage = UIImage(named: "BlackRectangle_50x50.jpg")!
    
    let poolManager = ImagePoolManager(images: [redImage, greenImage, blueImage, lightGreenImage, blackImage])

    func test() {
        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileSize = CGSize(width: 50.0, height: 50.0)
        let imageTileSequence = ImageTileSequence(numberOfTiles: 2, imageSize: CGSize(width: 100.0, height: 100.0))
        
        let positions = poolTileMapper.imagePositions(for: imageTileSequence, of: [
            255,0, 0 , 1, // RED
            0, 255, 1, 1, // GREEN
            0, 0, 255, 1, // BLUE
            55, 165, 74, 1 // LIGHT GREEN
        ])
        
        let redPosition = positions[0]
        XCTAssertEqual(redPosition.image, PoolTileMapperTests.redImage)
        XCTAssertEqual(redPosition.position, CGPoint.zero)
        
        let greenPosition = positions[1]
        XCTAssertEqual(greenPosition.image, PoolTileMapperTests.greenImage)
        XCTAssertEqual(greenPosition.position, CGPoint(x: tileSize.width, y: 0))
        
        let bluePosition = positions[2]
        XCTAssertEqual(bluePosition.image, PoolTileMapperTests.blueImage)
        XCTAssertEqual(bluePosition.position, CGPoint(x: 0, y: tileSize.height))

        let lightGreenPosition = positions[3]
        XCTAssertEqual(lightGreenPosition.image, PoolTileMapperTests.lightGreenImage)
        XCTAssertEqual(lightGreenPosition.position, CGPoint(x: tileSize.width, y: tileSize.height))
    }

}
