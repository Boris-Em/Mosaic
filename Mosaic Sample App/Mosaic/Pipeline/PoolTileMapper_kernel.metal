//
//  PoolTileMapper_kernel.metal
//  Mosaic
//
//  Created by Boris Emorine on 10/27/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include "Color Helpers/ColorConversion.h"

/// Finds the closest color from a set of colors.
kernel void closestColor_kernel(const device uint16_t *average_colors [[buffer(0)]],
                                const device uint16_t *pool_colors [[buffer(1)]],
                                constant uint8_t &number_of_tiles [[ buffer(2) ]],
                                constant uint8_t &numnber_of_image_pool [[ buffer(3) ]],
                                device uint16_t *outVector [[ buffer(4) ]],
                                uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                                uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                                uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
    
    int index = (threadgroup_position_in_grid.y * number_of_tiles + threadgroup_position_in_grid.x);
    int averageColorIndex = index * 4;

    int referenceR = average_colors[averageColorIndex];
    int referenceG = average_colors[averageColorIndex + 1];
    int referenceB = average_colors[averageColorIndex + 2];
    
    half3 referenceLab = toLAB(referenceR, referenceG, referenceB);
    
    int bestColorIndex = 0;
    float bestDelta = MAXFLOAT;
    
    for (int i = 0; i < numnber_of_image_pool; i++) {
        int poolIndex = i * 4;
        int poolR = pool_colors[poolIndex];
        int poolG = pool_colors[poolIndex + 1];
        int poolB = pool_colors[poolIndex + 2];
        
        half3 poolLab = toLAB(poolR, poolG, poolB);
        
        float delta = sqrt((pow((float)(poolLab.x - referenceLab.x), 2) + pow((float)(poolLab.y - referenceLab.y), 2) + pow((float)(poolLab.z - referenceLab.z), 2)));
        
        if (delta < bestDelta) {
            bestDelta = delta;
            bestColorIndex = i;
        }
    }

    outVector[index] = bestColorIndex;
};
