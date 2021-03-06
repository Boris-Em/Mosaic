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
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let shaderLibrary = MetalResourceManager.shared.shaderLibrary
        let function = shaderLibrary.makeFunction(name: "averageColorZone_kernel")!
        do {
            let pipelineState = try shaderLibrary.device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Could not make compute pipeline State: \(error)")
        }
    }()
    
    func preHeat() {
        _ = pipelineState
    }
    
    func findAverageZoneColor(on image: CGImage, with imageSequence: Tiles) -> MTLBuffer {
        let metalDevice = MetalResourceManager.shared.device
        let textureLoader = MTKTextureLoader(device: metalDevice)
        let texture = try! textureLoader.newTexture(cgImage: image, options: [MTKTextureLoader.Option.SRGB: 0, MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.topLeft])
        return findAverageZoneColor(on: texture, with: imageSequence)
    }
    
    func findAverageZoneColor(on texture: MTLTexture, with imageSequence: Tiles) -> MTLBuffer {
        let metalDevice = MetalResourceManager.shared.device
        let commandQueue = metalDevice.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        encoder.setTexture(texture, index: 0)
        
        var output = [UInt16](repeating: 0, count: imageSequence.count * 4)
        let outputBuffer = metalDevice.makeBuffer(bytes: &output, length: MemoryLayout<UInt16>.stride * imageSequence.count * 4, options: [])
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
