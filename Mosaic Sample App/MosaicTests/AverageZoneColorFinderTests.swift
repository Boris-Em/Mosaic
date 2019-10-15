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
        let image = UIImage(named: "RedRectangle_50x50.jpg")!
        
        let numberOfTiles: CGFloat = 2
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        let tileSize = CGSize(width: imageSize.width / numberOfTiles, height: imageSize.height / numberOfTiles)
        let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
        
        let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
        let result = averageZoneColorFinder.find()
        
        // The average red value of the first tile
        let red = result[0]
        XCTAssertGreaterThanOrEqual(red, 250)
        XCTAssertLessThanOrEqual(red, 255)
    }
    
    // MARK - Performance
    
    private static let numberOfTiles: CGFloat = 20

    func testSpeedMetal() {
        measure {
            let image = UIImage(named: "RedRectangle_40x40.jpg")!
            
            let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
            let tileSize = CGSize(width: imageSize.width / AverageZoneColorFinderTests.numberOfTiles, height: imageSize.height / AverageZoneColorFinderTests.numberOfTiles)
            let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)
            
            let averageZoneColorFinder = AverageZoneColorFinder(image: image, imageSequence: imageSequence)
            let _ = averageZoneColorFinder.find()
        }
    }
    
    func testSpeedConcurrent() {
        measure {
            let image = UIImage(named: "RedRectangle_40x40.jpg")!
            
            let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
            let tileSize = CGSize(width: imageSize.width / AverageZoneColorFinderTests.numberOfTiles, height: imageSize.height / AverageZoneColorFinderTests.numberOfTiles)
            let imageSequence = ImageTileSequence(tileSize: tileSize, imageSize: imageSize)

            var frames = [CGRect.zero]
            
            imageSequence.forEach { (frame) in
                frames.append(frame)
            }
            
            var averageColors = Array(repeating: UIColor.black, count: frames.count)
            
            let averageColorFinder = AverageColorFinder(image: image)

            DispatchQueue.concurrentPerform(iterations: imageSequence.count) { (iteration) in
                let frame = frames[iteration]
                let averageColor = averageColorFinder.computeAverageColor(for: frame)!
                averageColors[iteration] = averageColor
            }
        }

    }

}
