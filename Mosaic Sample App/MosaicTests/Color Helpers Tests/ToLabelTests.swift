//
//  ToLabTests.swift
//  MosaicTests
//
//  Created by Boris Emorine on 12/22/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import XCTest
import MetalKit
@testable import Mosaic

class ToLabTests: XCTestCase {
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let shaderLibrary = MetalResourceManager.shared.shaderLibrary
        let function = shaderLibrary.makeFunction(name: "toLab_kernel")!
        do {
            let pipelineState = try shaderLibrary.device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Could not make compute pipeline State: \(error)")
        }
    }()

    func testBlue() {
        assert(color: UIColor.green, isEqualToLab: [86, -87, 83])
    }
    
    func testGray() {
        assert(color: UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0), isEqualToLab: [2, 0, 0])
    }
    
    func testRedish() {
        assert(color: UIColor(red: 174.0 / 255.0, green: 74.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0), isEqualToLab: [45, 42, 14])
    }
    
    private func assert(color: UIColor, isEqualToLab expectedLab: [Int16]) {
        let metalDevice = MetalResourceManager.shared.device

        let commandQueue = metalDevice.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        let color = color.rgba

        // Average color of each tile
        encoder.setBytes(color, length: MemoryLayout<UInt16>.size * 4, index: 0)

        var output = [Int16](repeating: 0, count: 3)
        let outputBuffer = metalDevice.makeBuffer(bytes: &output, length: MemoryLayout<Int16>.stride * 3, options: [])!
        encoder.setBuffer(outputBuffer, offset: 0, index: 1)

        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: 1, height: 1, depth: 1)
        
        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        var lab = [Int16](repeating: 0, count: 3)
        let data = NSData(bytesNoCopy: (outputBuffer.contents()), length: MemoryLayout<Int16>.stride * 3, freeWhenDone: false)
        data.getBytes(&lab, length: MemoryLayout<Int16>.stride * 3)
        
        let l = lab[0]
        let a = lab[1]
        let b = lab[2]
        
        XCTAssertGreaterThanOrEqual(l, expectedLab[0] - 1)
        XCTAssertLessThanOrEqual(l, expectedLab[0] + 1)
        
        XCTAssertGreaterThanOrEqual(a, expectedLab[1] - 1)
        XCTAssertLessThanOrEqual(a, expectedLab[1] + 1)
        
        XCTAssertGreaterThanOrEqual(b, expectedLab[2] - 1)
        XCTAssertLessThanOrEqual(b, expectedLab[2] + 1)
    }
    
}
