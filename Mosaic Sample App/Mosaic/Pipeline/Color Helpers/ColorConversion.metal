//
//  ColorConversion.metal
//  Mosaic
//
//  Created by Boris Emorine on 11/25/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

half3 toXYZ(int r, int g, int b) {
    half var_R = (r / 255.0);
    half var_G = (g / 255.0);
    half var_B = (b / 255.0);

    if (var_R > 0.04045) {
        var_R = pow((var_R + 0.055) / 1.055, 2.4);
    } else {
        var_R = var_R / 12.92;
    }
    
    if ( var_G > 0.04045 ) {
        var_G = pow((var_G + 0.055) / 1.055, 2.4);
    } else {
        var_G = var_G / 12.92;
    }
    
    if ( var_B > 0.04045 ) {
        var_B = pow((var_B + 0.055) / 1.055, 2.4);
    } else {
        var_B = var_B / 12.92;
    }

    var_R = var_R * 100.0;
    var_G = var_G * 100.0;
    var_B = var_B * 100.0;

    half X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
    half Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
    half Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
    
    return half3(X, Y , Z);
};

half3 toLAB(int r, int g, int b) {
    half3 XYZ = toXYZ(r, g, b);
    
    half X = XYZ.x / 100.0;
    half Y = XYZ.y / 100.0;
    half Z = XYZ.z / 100.0;
    
    if (X > 0.008856) {
        X = pow(X, half(1.0 / 3.0));
    } else {
        X = (7.787 * X) + (16.0 / 116.0);
    }

    if (Y > 0.008856) {
        Y = pow(Y, half(1.0 / 3.0));
    } else {
        Y = (7.787 * Y) + (16.0 / 116.0);
    }
    
    if (Z > 0.008856) {
        Z = pow(Z, half(1.0 / 3.0));
    } else {
        Z = (7.787 * Z) + (16.0 / 116.0);
    }
    
    half L = (116 * Y) - 16;
    half A = 500 * (X - Y);
    half B = 200 * (Y - Z);
    
    return half3(L, A, B);
};
