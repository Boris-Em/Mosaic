//
//  AverageZoneColorFinderPerformanceTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 10/12/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class AverageZoneColorFinderPerformanceTests: XCTestCase {
    
    private static let numberOfTiles = 20

    func testSpeedMetal() {
        measure {
            let image = UIImage(named: "RedRectangle_40x40.jpg")!.cgImage!
            
            let imageSize = CGSize(width: image.width, height: image.height)
            let imageSequence = ImageTileSequence(numberOfTiles: AverageZoneColorFinderPerformanceTests.numberOfTiles, imageSize: imageSize)
            
            let averageZoneColorFinder = AverageZoneColorFinder()
            let _ = averageZoneColorFinder.findAverageZoneColor(on: image, with: imageSequence)
        }
    }
    
    func testSpeedConcurrent() {
        measure {
            let image = UIImage(named: "RedRectangle_40x40.jpg")!
            
            let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
            let imageSequence = ImageTileSequence(numberOfTiles: AverageZoneColorFinderPerformanceTests.numberOfTiles, imageSize: imageSize)

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
