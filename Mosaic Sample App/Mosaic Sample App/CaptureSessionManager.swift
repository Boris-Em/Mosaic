//
//  CaptureManager.swift
//  Mosaic Sample App
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

/// The CaptureSessionManager is responsible for setting up and managing the AVCaptureSession and the functions related to capturing.
final class CaptureSessionManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let captureSession = AVCaptureSession()
    
    var textureCache: CVMetalTextureCache!
    var metalDevice = MTLCreateSystemDefaultDevice()!
    
    weak var delegate: CaptureSessionManagerDelegate?
    
    var exposure: Float {
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Could not get input device")
        }
        
        return 1 / (Float(inputDevice.exposureDuration.value) / Float(inputDevice.exposureDuration.timescale))
    }
    
    var iso: Float {
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Could not get input device")
        }
        
        return inputDevice.iso
    }
    
    var minISO: Float {
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Could not get input device")
        }
        
        return inputDevice.activeFormat.minISO
    }
    
    var maxISO: Float {
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Could not get input device")
        }
        
        return inputDevice.activeFormat.maxISO
    }
    
    var minExposure: Float {
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Could not get input device")
        }

        return 1 / (Float(inputDevice.activeFormat.minExposureDuration.value) / Float(inputDevice.activeFormat.minExposureDuration.timescale))
    }
    
    var maxExposure: Float {
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("Could not get input device")
        }
        
        return 1 / (Float(inputDevice.activeFormat.maxExposureDuration.value) / Float(inputDevice.activeFormat.maxExposureDuration.timescale))
    }
    
    // MARK: Life Cycle
    
    override init() {
        super.init()
        
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, metalDevice, nil, &textureCache)
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_ouput_queue"))
        
        let settings: [String : Any] = [
          kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        
        videoOutput.videoSettings = settings
        
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let deviceInput = try? AVCaptureDeviceInput(device: inputDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(videoOutput) else {
                return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
        let targetFrameRate = 15.0
        let targetHeightResolution = Int32(400)..<Int32(800)
        
        let potentialFormats = inputDevice.formats.filter { (format) -> Bool in
            guard format.videoSupportedFrameRateRanges.contains(where: { (frameRateRange) -> Bool in
                return frameRateRange.maxFrameRate >= targetFrameRate && frameRateRange.minFrameRate <= targetFrameRate
            }) else {
                return false
            }
            
            let formatDescription = format.formatDescription
            let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
            
            return targetHeightResolution.contains(dimensions.height)
        }
        
        guard var bestFormat = potentialFormats.first else {
            fatalError("Could not get format matching our desires")
        }
        
        potentialFormats.forEach { (format) in
            if format.maxISO > bestFormat.maxISO {
                bestFormat = format
            }
        }
        
        try! inputDevice.lockForConfiguration()
        inputDevice.activeFormat = bestFormat
        
        let timeValue = Int64(1200.0 / targetFrameRate)
        let timeScale: Int64 = 1200
        
        inputDevice.activeVideoMinFrameDuration = CMTimeMake(value: timeValue, timescale: Int32(timeScale))
        inputDevice.activeVideoMaxFrameDuration = CMTimeMake(value: timeValue, timescale: Int32(timeScale))
        
        // 750xrx..
        inputDevice.exposureMode = .continuousAutoExposure
        inputDevice.focusMode = .continuousAutoFocus
        inputDevice.whiteBalanceMode = .continuousAutoWhiteBalance

        inputDevice.unlockForConfiguration()
        print("Frame Rate Set: \(inputDevice.activeFormat)")
        
        let connection = videoOutput.connection(with: .video)
        connection?.videoOrientation = .portrait
                
        captureSession.commitConfiguration()
    }
    
    // MARK: Capture Session Life Cycle
    
    /// Starts the camera and detecting quadrilaterals.
    internal func start() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authorizationStatus {
        case .authorized:
            self.captureSession.startRunning()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (_) in
                DispatchQueue.main.async { [weak self] in
                    self?.start()
                }
            })
        default:
            return
        }
    }
    
    internal func stop() {
        captureSession.stopRunning()
    }
        
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        var textureRef : CVMetalTexture?
        
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, nil, .bgra8Unorm, width, height, 0, &textureRef)
        let texture = CVMetalTextureGetTexture(textureRef!)!

        DispatchQueue.main.async {
            self.delegate?.didCapture(texture)
        }
    }
    
}

protocol CaptureSessionManagerDelegate: NSObjectProtocol {
    func didCapture(_ texture: MTLTexture)
}
