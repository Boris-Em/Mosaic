//
//  ImageStitcher.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit
import MetalKit

class ImageStitcher {
    
    /// A structure that keeps track of which image (texture) needs to be drawn.
    struct TexturePoolGuide {
        
        /// An array of indeces.
        /// The indeces refer to the texture to use in the pool.
        let indeces: MTLBuffer
        
        /// The textures to pick from and draw.
        let texturePool: [MTLTexture]
    }
    
    private lazy var device: MTLDevice = {
        return MTLCreateSystemDefaultDevice()!
    }()
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let defaultLibrary: MTLLibrary! = self.device.makeDefaultLibrary()
        let function = defaultLibrary.makeFunction(name: "imageStitch_kernel")!
        let pipelineState = try! self.device.makeComputePipelineState(function: function)
        return pipelineState
    }()
    
    func stitch(texturePositions: TexturePoolGuide, to size: CGSize, numberOfTiles: Int) -> MTLTexture {
        let commandQueue = self.device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        encoder.setTextures(texturePositions.texturePool, range: 0 ..< texturePositions.texturePool.count)
        
        let firstIndexAfterImagePool = 29
        
        encoder.setBuffer(texturePositions.indeces, offset: 0, index: firstIndexAfterImagePool)
        
        var cNumberOfTiles: UInt8 = UInt8(numberOfTiles)
        encoder.setBytes(&cNumberOfTiles, length: MemoryLayout<UInt8>.size, index: firstIndexAfterImagePool + 1)
        
        let outTextureDescriptor = MTLTextureDescriptor()
        outTextureDescriptor.pixelFormat = .bgra8Unorm_srgb
        outTextureDescriptor.width = Int(size.width)
        outTextureDescriptor.height = Int(size.height)
        outTextureDescriptor.usage = [MTLTextureUsage.shaderWrite, MTLTextureUsage.shaderRead]
        
        let outTexture = device.makeTexture(descriptor: outTextureDescriptor)!
        
        encoder.setTexture(outTexture, index: firstIndexAfterImagePool + 2)
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: numberOfTiles, height: numberOfTiles, depth: 1)

        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
                
        return outTexture
    }

}
