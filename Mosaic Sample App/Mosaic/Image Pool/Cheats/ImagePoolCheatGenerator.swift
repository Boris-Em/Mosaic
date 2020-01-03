//
//  ImagePoolCheatGenerator.swift
//  Mosaic
//
//  Created by Boris Emorine on 12/21/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

/// Generates images that will complete the image pool if needed.
/// This is particularly useful if the image pool can't represent enough colors.
struct ImagePoolCheatGenerator {
    
    /// A simple structure that represents a cheat - that is, an image and its associated color.
    struct Cheat {
        let image: UIImage
        let averageColor: [UInt16]
    }
    
    static let referencePalette = [
        // Grays
        UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0),
        UIColor(red: 35.0 / 255.0, green: 35.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0),
        UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0),
        UIColor(red: 90.0 / 255.0, green: 90.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0),
        UIColor(red: 175.0 / 255.0, green: 175.0 / 255.0, blue: 175.0 / 255.0, alpha: 1.0),
        UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0),
        UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0),

        // Amstrad palette https://en.wikipedia.org/wiki/List_of_8-bit_computer_hardware_graphics#CPC_series
        UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Black
        UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Blue
        UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Bright blue
        UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Red
        UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Magenta
        UIColor(red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Violet
        UIColor(red: 255.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Bright red
        UIColor(red: 255.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Purple
        UIColor(red: 255.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Bright magenta
        UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Green
        UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Cyan
        UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Sky blue
        UIColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Yellow
        UIColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Gray
        UIColor(red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Pale blue
        UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Orange
        UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Pink
        UIColor(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Pale magenta
        UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Bright green
        UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Sea green
        UIColor(red: 0.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Bright cyan
        UIColor(red: 128.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Lime green
        UIColor(red: 128.0 / 255.0, green: 255.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Pale green
        UIColor(red: 128.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Pale cyan
        UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0), // Bright yellow
        UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0), // Yellow
        UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), // Bright white
        UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0), // Beige
        UIColor(red: 255.0 / 255.0, green: 253.0 / 255.0, blue: 208 / 255.0, alpha: 1.0), // Beige
    ]
    
    /// Generates the missing colors and corresponding images to make sure we have a complete palette of colors.
    static func generateCheats(for imagePoolColors: [UInt16], images: [UIImage]) -> [Cheat] {
        var cheats = [Cheat]()
        for color in referencePalette {
            let distances = ColorsDistanceCalculator().execute(with: color, colorsToCompare: imagePoolColors)
            
            if let minDistance = distances.min(), minDistance > 20 {
                // The closest color isn't close enough.
                // Let's create a new image that will have an average color that's closer.
                guard let index = distances.firstIndex(of: minDistance) else {
                    fatalError("Something went wrong when trying to grab the image to base the cheat on.")
                }
            
                let imageToTweak = images[index]
                let colorToAim = color
                
                guard let cheatImage = ColorOverlayImageFilter.image(from: imageToTweak, with: color, targetSize: CGSize(width: 300.0, height: 300.0)) else {
                    continue
                }

                let cheat = ImagePoolCheatGenerator.Cheat(image: cheatImage, averageColor: colorToAim.rgba)
                cheats.append(cheat)
            }
        }
        
        return cheats
    }
    
}
