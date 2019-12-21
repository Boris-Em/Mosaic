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
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let shaderLibrary = MetalResourceManager.shared.shaderLibrary
        let function = shaderLibrary.makeFunction(name: "imageStitch_kernel")!
        do {
            let pipelineState = try shaderLibrary.device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Could not make compute pipeline State: \(error)")
        }
    }()
    
    func stitch(texturePositions: TexturePoolGuide, to size: CGSize, numberOfTiles: Int) -> MTLTexture {
        let metalDevice = MetalResourceManager.shared.device
        let commandQueue = metalDevice.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        encoder.setTextures(texturePositions.texturePool, range: 3 ..< texturePositions.texturePool.count + 3)
                
        encoder.setBuffer(texturePositions.indeces, offset: 0, index: 0)
        
        var cNumberOfTiles: UInt8 = UInt8(numberOfTiles)
        encoder.setBytes(&cNumberOfTiles, length: MemoryLayout<UInt8>.size, index: 1)
        
        let outTextureDescriptor = MTLTextureDescriptor()
        outTextureDescriptor.pixelFormat = .bgra8Unorm_srgb
        outTextureDescriptor.width = Int(size.width)
        outTextureDescriptor.height = Int(size.height)
        outTextureDescriptor.usage = [MTLTextureUsage.shaderWrite, MTLTextureUsage.shaderRead]
        
        let outTexture = metalDevice.makeTexture(descriptor: outTextureDescriptor)!
        
        encoder.setTexture(outTexture, index: 2)
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: numberOfTiles, height: numberOfTiles, depth: 1)

        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
                
        return outTexture
    }

}
