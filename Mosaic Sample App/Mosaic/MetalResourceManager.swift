//
//  MetalDevice.swift
//  Mosaic
//
//  Created by Boris Emorine on 12/21/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import Foundation
import MetalKit

/// This class is meant to be used as a shared instance (singleton) for Metal resource that need to be created once.
class MetalResourceManager {
    
    static let shared = MetalResourceManager()
    
    lazy var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create Metal device.")
        }
        
        return device
    }()
    
    lazy var shaderLibrary: MTLLibrary = {
        let frameworkBundle = Bundle(for: type(of: self))
        do {
            let shaderLibrary = try device.makeDefaultLibrary(bundle: frameworkBundle)
            return shaderLibrary
        } catch {
            fatalError("Could not make Default Metal Library: \(error)")
        }
    }()
    
}
