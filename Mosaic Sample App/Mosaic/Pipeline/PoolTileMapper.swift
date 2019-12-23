//
//  PoolTileMapper.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/16/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit
import MetalKit

/// Maps images from the pool to each tile on the mosaic image.
final class PoolTileMapper {
    
    private let poolManager: ImagePoolManager
    private let resizedImageManager = ResizedImageManager()
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let shaderLibrary = MetalResourceManager.shared.shaderLibrary
        let function = shaderLibrary.makeFunction(name: "closestColor_kernel")!
        do {
            let pipelineState = try shaderLibrary.device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Could not make compute pipeline State: \(error)")
        }
    }()
    
    init(poolManager: ImagePoolManager) {
        self.poolManager = poolManager
    }
    
    func preHeat(withTileSize tileSize: CGSize?) {
        _ = pipelineState
        poolManager.preHeat(withTileSize: tileSize)
    }
    
    /// Maps images from the pool to each tile.
    ///
    /// - Parameters:
    ///   - tileRects: The rectangles describing each tile.
    ///   - averageColors: The average color of each tile
    func match(_ tileRects: TileRects, to averageColors: MTLBuffer) -> ImageStitcher.TexturePoolGuide {
        preHeat(withTileSize: tileRects.tileSize)
        let metalDevice = MetalResourceManager.shared.device

        let commandQueue = metalDevice.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        // Average color of each tile
        encoder.setBuffer(averageColors, offset: 0, index: 0)
        
        // Average color of each image from the pool
        encoder.setBytes(poolManager.colors, length: MemoryLayout<UInt16>.size * poolManager.colors.count, index: 1)
        
        var cNumberOfTiles: UInt8 = UInt8(tileRects.numberOfTiles)
        encoder.setBytes(&cNumberOfTiles, length: MemoryLayout<UInt8>.size, index: 2)
        
        var cNumberOfImagesPool: UInt8 = UInt8(poolManager.images.count)
        encoder.setBytes(&cNumberOfImagesPool, length: MemoryLayout<UInt8>.size, index: 3)

        var output = [UInt16](repeating: 0, count: tileRects.count)
        let outputBuffer = metalDevice.makeBuffer(bytes: &output, length: MemoryLayout<UInt16>.stride * tileRects.count, options: [])
        encoder.setBuffer(outputBuffer, offset: 0, index: 4)
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: tileRects.numberOfTiles, height: tileRects.numberOfTiles, depth: 1)
        
        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        let poolPosition = ImageStitcher.TexturePoolGuide(indeces: outputBuffer!, texturePool: poolManager.textures)
        
        return poolPosition
    }
    
}
