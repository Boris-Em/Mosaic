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
        
    func testMulti100() {
        let redImage = UIImage(named: "RedRectangle_50x50.jpg")!
        let greenImage = UIImage(named: "GreenRectangle_50x50.jpg")!
        let blueImage = UIImage(named: "BlueRectangle_50x50.jpg")!
        let lightGreenImage = UIImage(named: "LightGreenRectangle_50x50.jpg")!
        let blackImage = UIImage(named: "BlackRectangle_50x50.jpg")!
        
        let poolManager = ImagePoolManager(images: [redImage, greenImage, blueImage, lightGreenImage, blackImage])
        
        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 2, imageSize: CGSize(width: 100.0, height: 100.0))
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "MultiRectangle_10x10.jpg")!.cgImage!, with: tileRects)
        
        let positions = poolTileMapper.imagePositions(for: tileRects, of: buffer)
        
        let redPosition = positions[0]
        XCTAssertEqual(redPosition.image, redImage)
        XCTAssertEqual(redPosition.position, CGPoint.zero)
        
        let greenPosition = positions[1]
        XCTAssertEqual(greenPosition.image, greenImage)
        XCTAssertEqual(greenPosition.position, CGPoint(x: tileRects.tileSize.width, y: 0))
        
        let bluePosition = positions[2]
        XCTAssertEqual(bluePosition.image, blueImage)
        XCTAssertEqual(bluePosition.position, CGPoint(x: 0, y: tileRects.tileSize.height))
        
        let lightGreenPosition = positions[3]
        XCTAssertEqual(lightGreenPosition.image, blueImage)
        XCTAssertEqual(lightGreenPosition.position, CGPoint(x: tileRects.tileSize.width, y: tileRects.tileSize.height))
    }
    
    func testMulti100Complex() {
        self.continueAfterFailure = false

        let redImage = UIImage(named: "RedRectangle_10x10.jpg")!
        let greenImage = UIImage(named: "GreenRectangle_10x10.png")!
        let blueImage = UIImage(named: "BlueRectangle_10x10.png")!
        let lightGreenImage = UIImage(named: "DarkGreenRectangle_10x10.png")!
        let blackImage = UIImage(named: "BlackRectangle_10x10.png")!
        
        let poolManager = ImagePoolManager(images: [redImage, greenImage, blueImage, lightGreenImage, blackImage])

        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 10, imageSize: CGSize(width: 100.0, height: 100.0))
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "MultiStripes_Aleternative_100x100.png")!.cgImage!, with: tileRects)
        
        
        
        let positions = poolTileMapper.imagePositions(for: tileRects, of: buffer)
        
        positions.forEach { (position) in
            let modulo = Int(position.position.x) % 3
            
            if modulo == 0 {
                XCTAssertEqual(position.image, greenImage)
            } else if modulo == 1 {
                XCTAssertEqual(position.image, blueImage)
            } else {
                XCTAssertEqual(position.image, redImage)
            }
        }
    }
    
    func testMulti1000Complex() {
        self.continueAfterFailure = false

        let redImage = UIImage(named: "RedRectangle_10x10.jpg")!
        let greenImage = UIImage(named: "GreenRectangle_10x10.png")!
        let blueImage = UIImage(named: "BlueRectangle_10x10.png")!
        let lightGreenImage = UIImage(named: "DarkGreenRectangle_10x10.png")!
        let blackImage = UIImage(named: "BlackRectangle_10x10.png")!
        
        let poolManager = ImagePoolManager(images: [redImage, greenImage, blueImage, lightGreenImage, blackImage])

        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 100, imageSize: CGSize(width: 1000.0, height: 1000.0))
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "MultiStripes_1000x1000.png")!.cgImage!, with: tileRects)
        
        
        
        let positions = poolTileMapper.imagePositions(for: tileRects, of: buffer)
        
        positions.forEach { (position) in
            let modulo = Int(position.position.x) % 3
            
            if modulo == 0 {
                XCTAssertEqual(position.image, redImage)
            } else if modulo == 1 {
                XCTAssertEqual(position.image, greenImage)
            } else {
                XCTAssertEqual(position.image, blueImage)
            }
        }
    }

}
