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
    
    if (var_G > 0.04045 ) {
        var_G = pow((var_G + 0.055) / 1.055, 2.4);
    } else {
        var_G = var_G / 12.92;
    }
    
    if (var_B > 0.04045 ) {
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
    
    half X = XYZ.x / 95.047;
    half Y = XYZ.y / 100.0;
    half Z = XYZ.z / 108.883;
    
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
    
    half L = (116.0 * Y) - 16.0;
    half A = 500.0 * (X - Y);
    half B = 200.0 * (Y - Z);
    
    return half3(L, A, B);
};

float deltaEWithRGB(half3 lhsRgb, half3 rhsRgb) {
    const float deltaE = sqrt((pow((rhsRgb.x - lhsRgb.x), 2) + pow((rhsRgb.y - lhsRgb.y), 2) + pow((rhsRgb.z - lhsRgb.z), 2)));
    return deltaE;
}

float deltaEWithCIE76(half3 lhsLab, half3 rhsLab) {
    const float deltaE = sqrt((pow((rhsLab.x - lhsLab.x), 2) + pow((rhsLab.y - lhsLab.y), 2) + pow((rhsLab.z - lhsLab.z), 2)));
    return deltaE;
}

float deltaEWithCIE94(half3 lhsLab, half3 rhsLab) {
    const half kL = 1.0;
    const half kC = 1.0;
    const half kH = 1.0;
    const half k1 = 0.045;
    const half k2 = 0.015;
    const half sL = 1.0;
    
    const half c1 = sqrt(pow(lhsLab.y, 2) + pow(lhsLab.z, 2));
    const half sC = 1 + k1 * c1;
    const half sH = 1 + k2 * c1;
            
    const half deltaL = lhsLab.x - rhsLab.x;
    const half deltaA = lhsLab.y - rhsLab.y;
    const half deltaB = lhsLab.z - rhsLab.z;
    
    const half c2 = sqrt(pow(rhsLab.y, 2) + pow(rhsLab.z, 2));
    const half deltaCab = c1 - c2;
    
    const half deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2));
    
    const half p1 = pow(deltaL / (kL * sL), 2);
    const half p2 = pow(deltaCab / (kC * sC), 2);
    const half p3 = pow(deltaHab / (kH * sH), 2);
    
    const half deltaE = sqrt(p1 + p2 + p3);

    return deltaE;
}
