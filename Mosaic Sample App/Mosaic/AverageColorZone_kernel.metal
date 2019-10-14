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
    
    
    int tile_width = inTexture.get_width() / number_of_tiles;
    int tile_height = inTexture.get_width() / number_of_tiles;

    int tile_x = tile_width * threadgroup_position_in_grid.x;
    int tile_y = tile_height * threadgroup_position_in_grid.y;
    
    int index = (threadgroup_position_in_grid.y * number_of_tiles + threadgroup_position_in_grid.x) * 4;
    
    int rTotal = 0;
    int gTotal = 0;
    int bTotal = 0;
    int count = 0;
    
    for(int i = tile_y; i<tile_y+tile_height; i++) {
        for(int j = tile_x; j<tile_x+tile_width; j++) {
            
            uint2 position = uint2(i, j);
            half4 color = inTexture.read(position);
            
            rTotal = rTotal + color.r * 255;
            gTotal = gTotal + color.g * 255;
            bTotal = bTotal + color.b * 255;
            count++;
        }
    }
    
    int rAverage = rTotal / count;
    int gAverage = gTotal / count;
    int bAverage = bTotal / count;
    
    outVector[index] = rAverage;
    outVector[index + 1] = gAverage;
    outVector[index + 2] = bAverage;
    outVector[index + 3] = 1;
};
