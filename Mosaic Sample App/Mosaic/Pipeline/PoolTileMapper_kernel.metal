//
//  PoolTileMapper_kernel.metal
//  Mosaic
//
//  Created by Boris Emorine on 10/27/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

/// Finds the closest color from a set of colors.
kernel void closestColor_kernel(const device uint16_t *average_colors [[buffer(0)]],
                                const device uint16_t *pool_colors [[buffer(1)]],
                                constant uint8_t &number_of_tiles [[ buffer(2) ]],
                                constant uint8_t &numnber_of_image_pool [[ buffer(3) ]],
                                device uint16_t *outVector [[ buffer(4) ]],
                                uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                                uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                                uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
    
    int index = (threadgroup_position_in_grid.y * number_of_tiles + threadgroup_position_in_grid.x) * 4;

    int referenceR = average_colors[index];
    int referenceG = average_colors[index + 1];
    int referenceB = average_colors[index + 2];
    
    int bestColorIndex = 0;
    float bestDelta = -1;
    
    for(int i = 0; i < numnber_of_image_pool; i++) {
        int index = i * 4;
        int poolR = pool_colors[index];
        int poolG = pool_colors[index + 1];
        int poolB = pool_colors[index + 2];
        
        float delta = sqrt((float)((poolR - referenceR) ^ 2 + (poolG - referenceG) ^ 2 + (poolB - referenceB) ^ 2));
        if (delta > bestDelta) {
            bestDelta = delta;
            bestColorIndex = index / 4;
        }
    }
    
    outVector[index / 4] = bestColorIndex;
};
