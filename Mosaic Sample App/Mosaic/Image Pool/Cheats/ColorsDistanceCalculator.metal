//
//  ColorsDistanceCalculator.metal
//  Mosaic
//
//  Created by Boris Emorine on 12/22/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include "../../Pipeline/Color Helpers/ColorConversion.h"

/// Finds the closest color from a set of colors.
kernel void colorImageScore_kernel(const device uint16_t *reference_color [[ buffer(0) ]],
                                   const device uint16_t *colors_to_compare [[ buffer(1) ]],
                                   constant uint8_t &number_of_colors [[ buffer(2) ]],
                                   device int16_t *outVector [[ buffer(3) ]],
                                   uint2 threadgroup_position_in_grid   [[ threadgroup_position_in_grid ]],
                                   uint2 thread_position_in_threadgroup [[ thread_position_in_threadgroup ]],
                                   uint2 threads_per_threadgroup        [[ threads_per_threadgroup ]]) {
    
    half3 referenceLab = toLAB(reference_color[0], reference_color[1], reference_color[2]);
    
    for (uint x = 0; x < number_of_colors; x++) {
        half3 toCompareLab = toLAB(colors_to_compare[x], colors_to_compare[x + 1], colors_to_compare[x + 2]);
        
        const half deltaE = deltaEWithCIE94(referenceLab, toCompareLab);
        outVector[x] = deltaE;
    }
}
