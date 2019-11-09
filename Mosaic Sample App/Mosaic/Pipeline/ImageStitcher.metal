//
//  ImageStitcher.metal
//  Mosaic
//
//  Created by Boris Emorine on 11/8/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void imageStitch_kernel(const array<texture2d<half>, 9> inTextures [[ texture(0) ]],
                                    const device uint16_t *indeces [[ buffer(9) ]],
                                    const device uint16_t *xPositions [[ buffer(10) ]],
                                    const device uint16_t *yPositions [[ buffer(11) ]],
                                    texture2d<half, access::write> outTexture [[ texture(12) ]],
                                    uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                                    uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                                    uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
    
    int tileIndex = (threadgroup_position_in_grid.y * 30 + threadgroup_position_in_grid.x);
    
    int poolIndex = indeces[tileIndex];
    
    uint2 positionInTexture = uint2(xPositions[tileIndex], yPositions[tileIndex]);
    
    for (uint x = 0; x < 30; x++) {
        for (uint y = 0; y < 30; y++) {
            uint2 readPosition = uint2(x, y);
            half4 colors = inTextures[poolIndex].read(readPosition);

            uint2 writePosition = uint2(positionInTexture.x + x, positionInTexture.y + y);
            
            outTexture.write(colors, writePosition);
        }
    }
    
}
