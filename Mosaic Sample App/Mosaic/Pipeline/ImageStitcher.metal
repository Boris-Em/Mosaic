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
                                    constant uint8_t &number_of_tiles [[ buffer(10) ]],
                                    texture2d<half, access::write> outTexture [[ texture(11) ]],
                                    uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                                    uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                                    uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
    
    int tileIndex = (threadgroup_position_in_grid.y * number_of_tiles + threadgroup_position_in_grid.x);
    
    int poolIndex = indeces[tileIndex];
    
    const texture2d<half> textureToDraw = inTextures[poolIndex];
    uint width = textureToDraw.get_width();
    uint height = textureToDraw.get_height();
    
    uint2 positionInTexture = uint2(threadgroup_position_in_grid.x * width, threadgroup_position_in_grid.y * height);
    
    for (uint x = 0; x < width; x++) {
        for (uint y = 0; y < height; y++) {
            uint2 readPosition = uint2(x, y);
            half4 colors = textureToDraw.read(readPosition);

            uint2 writePosition = uint2(positionInTexture.x + x, positionInTexture.y + y);
            
            outTexture.write(colors, writePosition);
        }
    }
    
}
