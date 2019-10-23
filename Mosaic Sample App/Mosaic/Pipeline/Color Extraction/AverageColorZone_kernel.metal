//
//  AverageColorZone_kernel.metal
//  Mosaic
//
//  Created by Boris Emorine on 10/12/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void averageColorZone_kernel(texture2d<half, access::read> inTexture [[ texture(0) ]],
                         device uint16_t *outVector [[ buffer(1) ]],
                         constant uint8_t &number_of_tiles [[ buffer(2) ]],
                         uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                         uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                         uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
        
    half rTotal = 0;
    half gTotal = 0;
    half bTotal = 0;
    half count = 0;
    
    int tile_width = inTexture.get_width() / number_of_tiles;
    int tile_height = inTexture.get_height() / number_of_tiles;
    
    int tile_x = tile_width * threadgroup_position_in_grid.x;
    int tile_y = tile_height * threadgroup_position_in_grid.y;
    
    for(int i = tile_y; i < tile_y + tile_height; i++) {
        for(int j = tile_x; j < tile_x + tile_width; j++) {
            
            uint2 position = uint2(i, j);
            half4 color = inTexture.read(position);
            
            rTotal = rTotal + color.r;
            gTotal = gTotal + color.g;
            bTotal = bTotal + color.b;
            count++;
        }
    }
    
    half rAverage = (rTotal / count) * 255;
    half gAverage = (gTotal / count) * 255;
    half bAverage = (bTotal / count) * 255;
    
    int index = (threadgroup_position_in_grid.y * number_of_tiles + threadgroup_position_in_grid.x) * 4;
    
    outVector[index] = rAverage;
    outVector[index + 1] = gAverage;
    outVector[index + 2] = bAverage;
    outVector[index + 3] = 1;
};
