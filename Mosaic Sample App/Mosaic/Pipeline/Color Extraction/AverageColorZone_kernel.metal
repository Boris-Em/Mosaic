//
//  AverageColorZone_kernel.metal
//  Mosaic
//
//  Created by Boris Emorine on 10/12/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

/// Finds the average color for a grid of rectangles on the given texture.
kernel void averageColorZone_kernel(texture2d<half, access::read> inTexture [[ texture(0) ]],
                         device uint16_t *outVector [[ buffer(1) ]],
                         constant uint8_t &number_of_tiles [[ buffer(2) ]],
                         uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                         uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                         uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
        
    int tile_width = inTexture.get_width() / number_of_tiles;
    int tile_height = inTexture.get_height() / number_of_tiles;

    int tile_x = tile_width * threadgroup_position_in_grid.x;
    int tile_y = tile_height * threadgroup_position_in_grid.y;
    
    uint2 position = uint2(tile_x + tile_width / 2, tile_y + tile_height / 2);
    half4 color = inTexture.read(position);
    
    int index = (threadgroup_position_in_grid.y * number_of_tiles + threadgroup_position_in_grid.x) * 4;
    
    outVector[index] = color.r * 255;
    outVector[index + 1] = color.g * 255;
    outVector[index + 2] = color.b * 255;
    outVector[index + 3] = 1;
};
