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
    
    func testBlack() {
        let redImage = UIImage(named: "RedRectangle_50x50.jpg")!
        let greenImage = UIImage(named: "GreenRectangle_50x50.jpg")!
        let blueImage = UIImage(named: "BlueRectangle_50x50.jpg")!
        let lightGreenImage = UIImage(named: "LightGreenRectangle_50x50.jpg")!
        let blackImage = UIImage(named: "BlackRectangle_50x50.jpg")!
        
        let poolManager = ImagePoolManager(images: [redImage, greenImage, blueImage, lightGreenImage, blackImage])
        
        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 50, imageSize: CGSize(width: 50.0, height: 50.0))
        
        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "BlackRectangle_50x50.jpg")!.cgImage!, with: tileRects)

        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        for i in 0..<tileRects.numberOfTiles {
            let expectedBlackIndex = Int(indeces[i])
            XCTAssertEqual(poolManager.images[expectedBlackIndex], blackImage)
        }
    }
    
    func testDarkGreen() {
        self.continueAfterFailure = false

        var images = [UIImage]()
        for i in 0..<27 {
            images.append(UIImage(named: "Rectangle_\(i).jpg")!)
        }
        
        let poolManager = ImagePoolManager(images: images)

        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 1, imageSize: CGSize(width: 121, height: 157))

        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "GreenRectangle_100x100.jpg")!.cgImage!, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let colorsData = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        colorsData.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)

        let averageColorImage = AverageZoneColorFinderTests().image(from: colors, tileRects: tileRects)
        
        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        let stitchedImage = PoolTileMapperTests.stitch(images: images, imageIndeces: indeces, tileRect: tileRects)
    }
        
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

        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        let expectedRedIndex = Int(indeces[0])
        XCTAssertEqual(poolManager.images[expectedRedIndex], redImage)
        
        let expectedGreenIndex = Int(indeces[1])
        XCTAssertEqual(poolManager.images[expectedGreenIndex], greenImage)

        let expectedBlueIndex = Int(indeces[2])
        XCTAssertEqual(poolManager.images[expectedBlueIndex], blueImage)

        let expectedLightBlueIndex = Int(indeces[3])
        XCTAssertEqual(poolManager.images[expectedLightBlueIndex], blueImage)
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

        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        for x in 0 ..< tileRects.numberOfTiles {
            for y in 0 ..< tileRects.numberOfTiles {
                let index = x + y * tileRects.numberOfTiles
                let image = poolManager.images[Int(indeces[index])]
                
                if x % 3 == 0 {
                    XCTAssertEqual(image, greenImage)
                } else if x % 3 == 1 {
                    XCTAssertEqual(image, blueImage)
                } else if x % 3 == 2 {
                    XCTAssertEqual(image, redImage)
                } else {
                    fatalError()
                }
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



        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        for x in 0 ..< tileRects.numberOfTiles {
            for y in 0 ..< tileRects.numberOfTiles {
                let index = x + y * tileRects.numberOfTiles
                let image = poolManager.images[Int(indeces[index])]
                
                if x % 3 == 0 {
                    XCTAssertEqual(image, redImage)
                } else if x % 3 == 1 {
                    XCTAssertEqual(image, greenImage)
                } else if x % 3 == 2 {
                    XCTAssertEqual(image, blueImage)
                } else {
                    fatalError()
                }
            }
        }
    }
    
    func testRealLife() {
        self.continueAfterFailure = false

        var images = [UIImage]()
        for i in 0..<27 {
            images.append(UIImage(named: "Rectangle_\(i).jpg")!)
        }
        
        images.append(UIImage(named: "Rectangle_0.jpg")!)
        images.append(UIImage(named: "Rectangle_10.jpg")!)

        let poolManager = ImagePoolManager(images: images)

        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 150, imageSize: CGSize(width: 3024, height: 4032))

        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "Test_image_6.jpg")!.cgImage!, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let colorsData = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        colorsData.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)

        let averageColorImage = AverageZoneColorFinderTests().image(from: colors, tileRects: tileRects)
        
        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        let stitchedImage = PoolTileMapperTests.stitch(images: images, imageIndeces: indeces, tileRect: tileRects)
        print(stitchedImage)
        print(averageColorImage)
    }
    
    func testBrown() {
        self.continueAfterFailure = false

        var images = [UIImage]()
        for i in 0..<27 {
            images.append(UIImage(named: "Rectangle_\(i).jpg")!)
        }
        
        let poolManager = ImagePoolManager(images: images)

        let poolTileMapper = PoolTileMapper(poolManager: poolManager)
        let tileRects = TileRects(numberOfTiles: 100, imageSize: CGSize(width: 100, height: 100))

        let averageZoneColorFinder = AverageZoneColorFinder()
        let buffer = averageZoneColorFinder.findAverageZoneColor(on: UIImage(named: "BrownRectangle_100x100.jpg")!.cgImage!, with: tileRects)
        
        var colors = [UInt16](repeating: 0, count: tileRects.rects.count * 4)
        
        let colorsData = NSData(bytesNoCopy: (buffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4, freeWhenDone: false)
        colorsData.getBytes(&colors, length: MemoryLayout<UInt16>.stride * tileRects.rects.count * 4)

        let averageColorImage = AverageZoneColorFinderTests().image(from: colors, tileRects: tileRects)
        
        let indecesBuffer = poolTileMapper.match(tileRects, to: buffer).indeces
        
        var indeces = [UInt16](repeating: 0, count: tileRects.rects.count)
        let data = NSData(bytesNoCopy: (indecesBuffer.contents()), length: MemoryLayout<UInt16>.stride * tileRects.rects.count, freeWhenDone: false)
        data.getBytes(&indeces, length: MemoryLayout<UInt16>.stride * tileRects.rects.count)
        
        let stitchedImage = PoolTileMapperTests.stitch(images: images, imageIndeces: indeces, tileRect: tileRects)
        print(stitchedImage)
        print(averageColorImage)
    }
        
}

extension PoolTileMapperTests {
    
    static func stitch(images: [UIImage], imageIndeces: [UInt16], tileRect: TileRects) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(tileRect.imageSize, true, 1.0)
        
        tileRect.rects.enumerated().forEach { (index, rect) in
            let imageIndex = imageIndeces[index]
            let image = images[Int(imageIndex)]
            image.draw(at: rect.origin, blendMode: .normal, alpha: 1.0)
        }
        
        let sticthedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        return sticthedImage
    }
    
}
