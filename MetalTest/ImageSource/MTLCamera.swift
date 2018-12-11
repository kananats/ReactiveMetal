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
    
    /// Latest `MTLTexture`
    private let texture: MutableProperty<MTLTexture>
    
    /// Texture cache
    private let textureCache: CVMetalTextureCache
    
    init?(device: MTLDevice, position: AVCaptureDevice.Position = .back) {
        self.device = device
        
        guard let textureCache = MTLHelper.makeTextureCache(device: device) else { return nil }
        
        self.textureCache = textureCache
        
        guard let texture = MTLHelper.makeEmptyTexture(width: 720, height: 1080, device: device) else { return nil }
        
        self.texture = MutableProperty(texture)
        
        super.init(position: position)
    }
}

// MARK: Inheritance
public extension MTLCamera {
    
    override func didReceiveSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
    
        // Makes `MTLTexture`
        guard let texture = MTLHelper.makeTexture(from: sampleBuffer, textureCache: self.textureCache, device: self.device) else { return }

        self.texture.swap(texture)
    }
}

// MARK: Protocol
extension MTLCamera: MTLImageSource {
    
    var output: SignalProducer<MTLTexture, NoError> { return self.texture.producer }
}
