//
//  MTLTextureExtensions.swift
//  Mosaic
//
//  Created by Boris Emorine on 1/4/20.
//  Copyright © 2020 Boris Emorine. All rights reserved.
//

import Metal
import CoreImage
import UIKit

/// Defines errors specific to converting `MTLTexture` instances.
enum MTLTextureConversionError: Error {
    
    /// Could not convert an `MTLTexture` instance to a `CIImage` instance.
    case ciImageConversion
    
    var localizedDescription: String {
        switch self {
        case .ciImageConversion:
            return "Something went wrong converting an `MTLTexture` instance to a `CIImage` instance."
        }
    }
}

extension MTLTexture {
    
    /// Converts the texture to a `UIImage` instance.
    func toImage() throws -> UIImage {
        
        let options = [CIImageOption.colorSpace: CGColorSpaceCreateDeviceRGB(),
                          CIContextOption.outputPremultiplied: true,
                          CIContextOption.useSoftwareRenderer: false] as! [CIImageOption : Any]
        
        guard var ciImage = CIImage(mtlTexture: self, options: options) else {
            throw MTLTextureConversionError.ciImageConversion
        }
        
        ciImage = ciImage.oriented(CGImagePropertyOrientation.downMirrored)
        let uiImage = UIImage(ciImage: ciImage)

        return uiImage
    }
    
}
