//
//  MTLCamera.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import Result
import ReactiveSwift

import UIKit

// MARK: Main
public final class MTLCamera: Camera {
    
    let device: MTLDevice
    
    /// Pipe for observing `MTLTexture` output
    private let pipe = Signal<MTLTexture, NoError>.pipe()
    
    /// Texture cache
    private let textureCache: CVMetalTextureCache
    
    init?(device: MTLDevice, position: AVCaptureDevice.Position = .back) {
        self.device = device
        
        guard let textureCache = MTLHelper.makeTextureCache(device: device) else { return nil }
        
        self.textureCache = textureCache
        
        super.init(position: position)
    }
}

// MARK: Inheritance
public extension MTLCamera {
    
    override func didReceiveSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        
        // Makes `MTLTexture` and forward to pipe
        guard let texture = MTLHelper.makeTexture(from: sampleBuffer, textureCache: self.textureCache, device: self.device) else { return }
        
        // self.pipe.input.send(value: texture)
        
        let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        
        let image : UIImage = self.convert(cmage: ciimage)
        
        guard let kuy = MTLHelper.makeTexture(from: image, device: self.device) else { return }
        
        self.pipe.input.send(value: kuy)
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}

// MARK: Protocol
extension MTLCamera: MTLImageSource {
    
    var output: Signal<MTLTexture, NoError> { return self.pipe.output }
}
