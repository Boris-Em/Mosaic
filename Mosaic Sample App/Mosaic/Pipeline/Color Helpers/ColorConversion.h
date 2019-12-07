//
//  ColorConversion.h
//  Mosaic Sample App
//
//  Created by Boris Emorine on 11/25/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

#ifndef ColorConversion_HEADERS
#define ColorConversion_HEADERS

half3 toXYZ(int r, int g, int b);
half3 toLAB(int r, int g, int b);
float deltaEWithCIE94(half3 lhsLab, half3 rhsLab);

#endif /* ColorConversion_h */
