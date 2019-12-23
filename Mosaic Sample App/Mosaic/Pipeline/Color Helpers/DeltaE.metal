//
//  DeltaE.metal
//  MosaicTests
//
//  Created by Boris Emorine on 12/22/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#include "ColorConversion.h"

kernel void deltaE_kernel(const device uint16_t *color_1 [[ buffer(0) ]],
                         const device uint16_t *color_2 [[ buffer(1) ]],
                                   device int16_t *outVector [[ buffer(2) ]]) {
    
    half3 lab_1 = toLAB(color_1[0], color_1[1], color_1[2]);
    half3 lab_2 = toLAB(color_2[0], color_2[1], color_2[2]);
    
    float deltaE = deltaEWithCIE94(lab_1, lab_2);
    
    outVector[0] = deltaE;
}
