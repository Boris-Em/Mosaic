//
//  AverageZoneColorFinder.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/12/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit
import MetalKit

/// This class provides a fast way of finding the average color of multiple zones of an image.
class AverageZoneColorFinder {

    private lazy var device: MTLDevice = {
        return MTLCreateSystemDefaultDevice()!
    }()
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let defaultLibrary: MTLLibrary! = self.device.makeDefaultLibrary()
        let function = defaultLibrary.makeFunction(name: "averageColorZone_kernel")!
        let pipelineState = try! self.device.makeComputePipelineState(function: function)
        return pipelineState
    }()
    
    func preHeat() {
        _ = pipelineState
    }
    
    func findAverageZoneColor(on image: CGImage, with imageSequence: TileRects) -> MTLBuffer {
        let textureLoader = MTKTextureLoader(device: self.device)
        let texture = try! textureLoader.newTexture(cgImage: image, options: [MTKTextureLoader.Option.SRGB: 0, MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.topLeft])
        return findAverageZoneColor(on: texture, with: imageSequence)
    }
    
    func findAverageZoneColor(on texture: MTLTexture, with imageSequence: TileRects) -> MTLBuffer {
        let commandQueue = self.device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        encoder.setTexture(texture, index: 0)
        
        var output = [UInt16](repeating: 0, count: imageSequence.count * 4)
        let outputBuffer = self.device.makeBuffer(bytes: &output, length: MemoryLayout<UInt16>.stride * imageSequence.count * 4, options: [])
        encoder.setBuffer(outputBuffer, offset: 0, index: 1)
        
        var cNumberOfTiles: UInt8 = UInt8(imageSequence.numberOfTiles)
        encoder.setBytes(&cNumberOfTiles, length: MemoryLayout<UInt8>.size, index: 2)
        
        let numberOfTiles = imageSequence.numberOfTiles
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: numberOfTiles, height: numberOfTiles, depth: 1)
        
        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return outputBuffer!
    }
    
}
