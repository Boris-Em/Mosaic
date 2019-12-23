//
//  ColorOverlayImageFilter.swift
//  Mosaic
//
//  Created by Boris Emorine on 12/23/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

/// The `ColorOverlayImageFilter` is responsible for adding an overlay of a specific color to a given image.
/// This will result in the new filtered image to be closer to the given color.
struct ColorOverlayImageFilter {
    
    static func image(from image: UIImage, with overlayColor: UIColor, targetSize: CGSize? = nil) -> UIImage? {
        var ciImage = image.ciImage
        
        if ciImage == nil {
            guard let cgImage = image.cgImage else {
                assertionFailure("Could not create `CIImage` from `UIImage` for Cheating.")
                return nil
            }
            
            ciImage = CIImage(cgImage: cgImage)
        }
        
        let overlayColor = CIColor(color: overlayColor.withAlphaComponent(0.95))
        let overlayParameters = [kCIInputColorKey: overlayColor]
        guard let overlayFilter = CIFilter(name: "CIConstantColorGenerator", parameters: overlayParameters) else {
            fatalError("Could not create `CIConstantColorGenerator` CIFilter.")
        }
        
        guard let overlayImage = overlayFilter.outputImage else {
            fatalError("Could not create overlay image.")
        }
        
        let colorOverlayParameters: [String : Any] = [
            kCIInputBackgroundImageKey: ciImage as Any,
            kCIInputImageKey: overlayImage
        ]
        guard let colorOverlayFilter = CIFilter(name: "CISourceOverCompositing", parameters: colorOverlayParameters) else {
            fatalError("Could not create `CISourceOverCompositing` CIFilter.")
        }
        guard var colorOverlayImage = colorOverlayFilter.outputImage else {
            fatalError("Could not create color overlay image.")
        }
        
        let targetSize = image.size
        let cropRect = CGRect(origin: .zero, size: targetSize)
        colorOverlayImage = colorOverlayImage.cropped(to: cropRect)
        
        return UIImage(ciImage: colorOverlayImage)
    }
    
}
