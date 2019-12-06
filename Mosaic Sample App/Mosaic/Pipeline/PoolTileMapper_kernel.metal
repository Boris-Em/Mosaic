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
    
    // CIE94
    
    float kL = 1.0;
    float kC = 1.0;
    float kH = 1.0;
    float k1 = 0.045;
    float k2 = 0.015;
    float sL = 1.0;
    
    float c1 = sqrt(pow(referenceLab.y, 2) + pow(referenceLab.z, 2));
    
    float sC = 1 + k1 * c1;
    float sH = 1 + k2 * c1;
    
    for (int i = 0; i < numnber_of_image_pool; i++) {
        int poolIndex = i * 4;
        int poolR = pool_colors[poolIndex];
        int poolG = pool_colors[poolIndex + 1];
        int poolB = pool_colors[poolIndex + 2];
        
        half3 poolLab = toLAB(poolR, poolG, poolB);
                
        float deltaL = referenceLab.x - poolLab.x;
        float deltaA = referenceLab.y - poolLab.y;
        float deltaB = referenceLab.z - poolLab.z;
        
        float c2 = sqrt(pow(poolLab.y, 2) + pow(poolLab.z, 2));
        float deltaCab = c1 - c2;
        
        float deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2));
        
        float p1 = pow(deltaL / (kL * sL), 2);
        float p2 = pow(deltaCab / (kC * sC), 2);
        float p3 = pow(deltaHab / (kH * sH), 2);
        
        float delta = sqrt(p1 + p2 + p3);
                
        if (delta < bestDelta) {
            bestDelta = delta;
            bestColorIndex = i;
        }
    }

    outVector[index] = bestColorIndex;
};
