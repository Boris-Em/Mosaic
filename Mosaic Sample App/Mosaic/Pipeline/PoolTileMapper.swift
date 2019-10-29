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
    
    private lazy var device: MTLDevice = {
        return MTLCreateSystemDefaultDevice()!
    }()
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let defaultLibrary: MTLLibrary! = self.device.makeDefaultLibrary()
        let function = defaultLibrary.makeFunction(name: "closestColor_kernel")!
        let pipelineState = try! self.device.makeComputePipelineState(function: function)
        return pipelineState
    }()
    
    init(poolManager: ImagePoolManager) {
        self.poolManager = poolManager
    }
    
    func preHeat() {
        _ = pipelineState
        poolManager.preHeat()
    }
    
    func imagePositions(for tileRects: TileRects, of averageColors: MTLBuffer) -> [ImagePositionValuePair] {
        preHeat()
        
        var result2 = [UInt16](repeating: 0, count: tileRects.count * 4)
        let data2 = NSData(bytesNoCopy: (averageColors.contents()), length: MemoryLayout<UInt16>.stride * tileRects.count * 4, freeWhenDone: false)
        data2.getBytes(&result2, length: MemoryLayout<UInt16>.stride * tileRects.count * 4)
        
        let commandQueue = self.device.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        // Average color of each tile
        encoder.setBuffer(averageColors, offset: 0, index: 0)
        
        encoder.setBytes(poolManager.colors, length: MemoryLayout<UInt16>.size * poolManager.colors.count, index: 1)
        
        var cNumberOfTiles: UInt8 = UInt8(tileRects.numberOfTiles)
        encoder.setBytes(&cNumberOfTiles, length: MemoryLayout<UInt8>.size, index: 2)
        
        var cNumberOfImagesPool: UInt8 = UInt8(poolManager.images.count)
        encoder.setBytes(&cNumberOfImagesPool, length: MemoryLayout<UInt8>.size, index: 3)

        var output = [UInt16](repeating: 0, count: tileRects.count)
        let outputBuffer = self.device.makeBuffer(bytes: &output, length: MemoryLayout<UInt16>.stride * tileRects.count, options: [])
        encoder.setBuffer(outputBuffer, offset: 0, index: 4)

        let numberOfTiles = tileRects.count
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: numberOfTiles, height: numberOfTiles, depth: 1)
        
        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        var result = [UInt16](repeating: 0, count: tileRects.count)
        let data = NSData(bytesNoCopy: (outputBuffer?.contents())!, length: MemoryLayout<UInt16>.stride * tileRects.count, freeWhenDone: false)
        data.getBytes(&result, length: MemoryLayout<UInt16>.stride * tileRects.count)
        
        var pairs = [ImagePositionValuePair]()
        
        for (index, rect) in tileRects.rects.enumerated() {
            let imageIndex = Int(result[index])
            let image = poolManager.images[imageIndex]
            let resizedImage = resizedImageManager.resizedImage(for: image, size: tileRects.tileSize)
            let pair = ImagePositionValuePair(image: resizedImage, position: rect.origin)
            pairs.append(pair)
        }
        
        return pairs
    }
    
}
