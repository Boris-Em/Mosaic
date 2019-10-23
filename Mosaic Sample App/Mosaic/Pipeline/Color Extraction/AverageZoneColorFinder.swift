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
    
    private let imageSequence: ImageTileSequence
    private let texture: MTLTexture
    
    private static let device = MTLCreateSystemDefaultDevice()!
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let defaultLibrary: MTLLibrary! = AverageZoneColorFinder.device.makeDefaultLibrary()
        let function = defaultLibrary.makeFunction(name: "averageColorZone_kernel")!
        let pipelineState = try! AverageZoneColorFinder.device.makeComputePipelineState(function: function)
        return pipelineState
    }()
    
    convenience init(image: CGImage, imageSequence: ImageTileSequence) {
        let textureLoader = MTKTextureLoader(device: AverageZoneColorFinder.device)
        let texture = try! textureLoader.newTexture(cgImage: image, options: [MTKTextureLoader.Option.SRGB: 0])
        self.init(texture: texture, imageSequence: imageSequence)
    }
    
    init(texture: MTLTexture, imageSequence: ImageTileSequence) {
        self.imageSequence = imageSequence
        self.texture = texture
    }
    
    func find() -> [UInt16] {
        let commandQueue = AverageZoneColorFinder.device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        encoder.setTexture(texture, index: 0)
        
        var output = [UInt16](repeating: 0, count: imageSequence.count * 4)
        let outputBuffer = AverageZoneColorFinder.device.makeBuffer(bytes: &output, length: MemoryLayout<UInt16>.stride * imageSequence.count * 4, options: [])
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
        
        var result = [UInt16](repeating: 0, count: imageSequence.count * 4)
        let data = NSData(bytesNoCopy: (outputBuffer?.contents())!, length: MemoryLayout<UInt16>.stride * imageSequence.count * 4, freeWhenDone: false)
        data.getBytes(&result, length: MemoryLayout<UInt16>.stride * imageSequence.count * 4)
        
        return result
    }
    
}
