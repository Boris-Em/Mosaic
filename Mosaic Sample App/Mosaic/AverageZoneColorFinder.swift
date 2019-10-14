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
    
    private let image: UIImage
    private let cgImage: CGImage
    private let imageSequence: ImageTileSequence
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let defaultLibrary:MTLLibrary! = device.makeDefaultLibrary()
        let function = defaultLibrary.makeFunction(name: "averageColorZone_kernel")!
        let pipelineState = try! device.makeComputePipelineState(function: function)
        return pipelineState
    }()
    
    init(image: UIImage, imageSequence: ImageTileSequence) {
        self.image = image
        self.imageSequence = imageSequence
        self.cgImage = image.cgImage!
    }
    
    func find() {
        let commandQueue = device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        let textureLoader = MTKTextureLoader(device: device)
        let texture = try! textureLoader.newTexture(cgImage: cgImage, options: nil)
        encoder.setTexture(texture, index: 0)
        
        var output = [UInt16](repeating: 0, count: imageSequence.count * 4)
        let outputBuffer = device.makeBuffer(bytes: &output, length: MemoryLayout<UInt16>.stride * imageSequence.count * 4, options: [])
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

        print(result)
    }
    
}
