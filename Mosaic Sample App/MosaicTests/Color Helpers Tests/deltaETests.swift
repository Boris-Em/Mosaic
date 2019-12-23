//
//  deltaETests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 12/22/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
@testable import Mosaic

class deltaETests: XCTestCase {
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let shaderLibrary = MetalResourceManager.shared.shaderLibrary
        let function = shaderLibrary.makeFunction(name: "deltaE_kernel")!
        do {
            let pipelineState = try shaderLibrary.device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Could not make compute pipeline State: \(error)")
        }
    }()

    func testGreenBlue() {
        let color1 = UIColor.green
        let color2 = UIColor.blue
        
        assert(color1: color1, color2: color2, areWithin: 105)
    }
    
    func testGrayRedish() {
        let color1 = UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
        let color2 = UIColor(red: 174.0 / 255.0, green: 74.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
        
        assert(color1: color1, color2: color2, areWithin: 61)
    }
    
    func testSimilar() {
        let color1 = UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
        let color2 = UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
        
        assert(color1: color1, color2: color2, areWithin: 0)
    }
    
    func testRedishPurple() {
        let color1 = UIColor(red: 100.0 / 255.0, green: 45.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0)
        let color2 = UIColor(red: 95.0 / 255.0, green: 14.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
        
        assert(color1: color1, color2: color2, areWithin: 57)
    }
    
    private func assert(color1: UIColor, color2: UIColor, areWithin expectedDistance: Int) {
        let metalDevice = MetalResourceManager.shared.device
        
        let color1 = color1.rgba
        let color2 = color2.rgba

        let commandQueue = metalDevice.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)

        // Average color of each tile
        encoder.setBytes(color1, length: MemoryLayout<UInt16>.size * 4, index: 0)
        encoder.setBytes(color2, length: MemoryLayout<UInt16>.size * 4, index: 1)

        var output = [Int16](repeating: 0, count: 1)
        let outputBuffer = metalDevice.makeBuffer(bytes: &output, length: MemoryLayout<Int16>.stride * 1, options: [])!
        encoder.setBuffer(outputBuffer, offset: 0, index: 2)

        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: 1, height: 1, depth: 1)
        
        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        var deltaE = [Int16](repeating: 0, count: 1)
        let data = NSData(bytesNoCopy: (outputBuffer.contents()), length: MemoryLayout<Int16>.stride * 1, freeWhenDone: false)
        data.getBytes(&deltaE, length: MemoryLayout<Int16>.stride * 1)

        XCTAssertGreaterThanOrEqual(deltaE[0], Int16(expectedDistance - 1))
        XCTAssertLessThanOrEqual(deltaE[0], Int16(expectedDistance + 1))
    }
    
}
