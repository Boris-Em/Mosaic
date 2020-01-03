//
//  ColorsDistanceCalculator.swift
//  Mosaic
//
//  Created by Boris Emorine on 12/21/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

/// Takes one reference color, and an array of colors as input.
/// Outputs the distance between the reference color and every color from the array.
class ColorsDistanceCalculator {
    
    private lazy var pipelineState: MTLComputePipelineState = {
        let shaderLibrary = MetalResourceManager.shared.shaderLibrary
        let function = shaderLibrary.makeFunction(name: "colorImageScore_kernel")!
        do {
            let pipelineState = try shaderLibrary.device.makeComputePipelineState(function: function)
            return pipelineState
        } catch {
            fatalError("Could not make compute pipeline State: \(error)")
        }
    }()
    
    /// Returns: an array of values indicating how close the reference color is to the colors to compare. The closer the value is to 1, the closer the colors are.
    func execute(with referenceColor: UIColor, colorsToCompare: [UInt16]) -> [Int16] {
        let metalDevice = MetalResourceManager.shared.device
        let commandQueue = metalDevice.makeCommandQueue()!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        encoder.setComputePipelineState(pipelineState)
        
        let referenceColor = referenceColor.rgba
        let outputCount = colorsToCompare.count / 4
        
        encoder.setBytes(referenceColor, length: MemoryLayout<UInt16>.size * referenceColor.count, index: 0)

        encoder.setBytes(colorsToCompare, length: MemoryLayout<UInt16>.size * colorsToCompare.count, index: 1)
        
        var cNumberOfColorsToCompare: UInt8 = UInt8(outputCount)
        encoder.setBytes(&cNumberOfColorsToCompare, length: MemoryLayout<UInt8>.size, index: 2)
        
        var output = [Int16](repeating: 0, count: outputCount)
        let outputBuffer = metalDevice.makeBuffer(bytes: &output, length: MemoryLayout<Int16>.stride * outputCount, options: [])!
        encoder.setBuffer(outputBuffer, offset: 0, index: 3)
        
        let threadsPerThreadgroup = MTLSizeMake(1, 1, 1)
        let threadgroupsPerGrid = MTLSize(width: 1, height: 1, depth: 1)
        
        encoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
        encoder.endEncoding()
                
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        var distances = [Int16](repeating: 0, count: outputCount)
        let data = NSData(bytesNoCopy: (outputBuffer.contents()), length: MemoryLayout<Int16>.stride * outputCount, freeWhenDone: false)
        data.getBytes(&distances, length: MemoryLayout<Int16>.stride * outputCount)

        return distances
    }
    
}
