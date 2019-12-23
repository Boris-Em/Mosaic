//
//  ToLab.metal
//  MosaicTests
//
//  Created by Boris Emorine on 12/22/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include "ColorConversion.h"

kernel void toLab_kernel(const device uint16_t *color [[ buffer(0) ]],
                                   device int16_t *outVector [[ buffer(1) ]]) {
    
    half3 referenceLab = toLAB(color[0], color[1], color[2]);
        
    outVector[0] = referenceLab.x;
    outVector[1] = referenceLab.y;
    outVector[2] = referenceLab.z;
}
