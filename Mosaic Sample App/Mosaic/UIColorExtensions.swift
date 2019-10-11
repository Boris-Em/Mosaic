//
//  UIColorExtensions.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

extension UIColor {
    
    var RGBA: [CGFloat] {
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0
        var A: CGFloat = 0
        self.getRed(&R, green: &G, blue: &B, alpha: &A)
        return [R,G,B,A]
    }
    
    var XYZ: [CGFloat] {
        // http://www.easyrgb.com/index.php?X=MATH&H=02#text2
        
        let RGBA = self.RGBA
        
        func XYZ_helper(c: CGFloat) -> CGFloat {
            return (0.04045 < c ? pow((c + 0.055)/1.055, 2.4) : c/12.92) * 100
        }
        
        let R = XYZ_helper(c: RGBA[0])
        let G = XYZ_helper(c: RGBA[1])
        let B = XYZ_helper(c: RGBA[2])
        
        let X: CGFloat = (R * 0.4124) + (G * 0.3576) + (B * 0.1805)
        let Y: CGFloat = (R * 0.2126) + (G * 0.7152) + (B * 0.0722)
        let Z: CGFloat = (R * 0.0193) + (G * 0.1192) + (B * 0.9505)
        
        return [X, Y, Z]
    }
    
    var LAB: [CGFloat] {
        // http://www.easyrgb.com/index.php?X=MATH&H=07#text7
        
        let XYZ = self.XYZ
        
        func LAB_helper(c: CGFloat) -> CGFloat {
            return 0.008856 < c ? pow(c, 1/3) : ((7.787 * c) + (16/116))
        }
        
        let X: CGFloat = LAB_helper(c: XYZ[0]/95.047)
        let Y: CGFloat = LAB_helper(c: XYZ[1]/100.0)
        let Z: CGFloat = LAB_helper(c: XYZ[2]/108.883)
        
        let L: CGFloat = (116 * Y) - 16
        let A: CGFloat = 500 * (X - Y)
        let B: CGFloat = 200 * (Y - Z)
        
        return [L, A, B]
    }
    
    func CIE94(compare color: UIColor) -> CGFloat {
        // https://en.wikipedia.org/wiki/Color_difference#CIE94
        
        let k_L:CGFloat = 1
        let k_C:CGFloat = 1
        let k_H:CGFloat = 1
        let k_1:CGFloat = 0.045
        let k_2:CGFloat = 0.015
        
        let LAB1 = self.LAB
        let L_1 = LAB1[0], a_1 = LAB1[1], b_1 = LAB1[2]
        
        let LAB2 = color.LAB
        let L_2 = LAB2[0], a_2 = LAB2[1], b_2 = LAB2[2]
        
        let deltaL:CGFloat = L_1 - L_2
        let deltaA:CGFloat = a_1 - a_2
        let deltaB:CGFloat = b_1 - b_2
        
        let C_1:CGFloat = sqrt(pow(a_1, 2) + pow(b_1, 2))
        let C_2:CGFloat = sqrt(pow(a_2, 2) + pow(b_2, 2))
        let deltaC_ab:CGFloat = C_1 - C_2
        
        let deltaH_ab:CGFloat = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaC_ab, 2))
        
        let s_L:CGFloat = 1
        let s_C:CGFloat = 1 + (k_1 * C_1)
        let s_H:CGFloat = 1 + (k_2 * C_1)
        
        // Calculate
        
        let P1:CGFloat = pow(deltaL/(k_L * s_L), 2)
        let P2:CGFloat = pow(deltaC_ab/(k_C * s_C), 2)
        let P3:CGFloat = pow(deltaH_ab/(k_H * s_H), 2)
        
        return sqrt((P1.isNaN ? 0:P1) + (P2.isNaN ? 0:P2) + (P3.isNaN ? 0:P3))
    }
    
}
