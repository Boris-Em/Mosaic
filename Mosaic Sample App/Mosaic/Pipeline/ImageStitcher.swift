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
    
    /// A structure that keeps track of where each image from the pool needs to be drawn.
    struct TexturePoolPositions {
        
        /// An array of indeces.
        /// The indeces refer to the texture pool to use.
        let indeces: MTLBuffer
        
        /// The positions where to draw each texture.
        let positions: [CGRect]
        
        /// The textures to draw.
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
    
    func stitch(texturePositions: TexturePoolPositions, to size: CGSize, numberOfTiles: Int) -> UIImage {
        let commandQueue = self.device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        encoder.setTextures(texturePositions.texturePool, range: 0 ..< texturePositions.texturePool.count)
        
        encoder.setBuffer(texturePositions.indeces, offset: 0, index: texturePositions.texturePool.count)
        
        let xPositions: [UInt16] = texturePositions.positions.map { (rect) -> UInt16 in
            return UInt16(rect.origin.x)
        }
        
        let yPositions: [UInt16] = texturePositions.positions.map { (rect) -> UInt16 in
            return UInt16(rect.origin.y)
        }
        
        encoder.setBytes(xPositions, length: MemoryLayout<UInt16>.size * xPositions.count, index: texturePositions.texturePool.count + 1)
        encoder.setBytes(yPositions, length: MemoryLayout<UInt16>.size * yPositions.count, index: texturePositions.texturePool.count + 2)
        
        let outTextureDescriptor = MTLTextureDescriptor()
        outTextureDescriptor.pixelFormat = .rgba8Unorm
        outTextureDescriptor.width = Int(size.width)
        outTextureDescriptor.height = Int(size.height)
        outTextureDescriptor.usage = [MTLTextureUsage.shaderWrite, MTLTextureUsage.shaderRead]
        
        let outTexture = device.makeTexture(descriptor: outTextureDescriptor)!
        
        encoder.setTexture(outTexture, index: texturePositions.texturePool.count + 3)
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: numberOfTiles, height: numberOfTiles, depth: 1)

        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        let outCIImage = CIImage(mtlTexture: outTexture, options: nil)!
        let outUIIMage = UIImage(ciImage: outCIImage)
        
        return outUIIMage
    }

}
