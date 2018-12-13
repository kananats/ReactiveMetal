//
//  MTLCamera.swift
//  ReactiveMetal
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

    /// Latest `MTLTexture`
    private let texture: MutableProperty<MTLTexture?>
    
    /// Texture cache
    private let textureCache: CVMetalTextureCache
    
    override init?(position: AVCaptureDevice.Position = .back) {
 
        guard let textureCache = MTL.default.makeTextureCache() else { return nil }
        
        self.textureCache = textureCache
        
        guard let texture = MTL.default.makeEmptyTexture() else { return nil }
        
        self.texture = MutableProperty<MTLTexture?>(texture)
        
        super.init(position: position)
    }
}

// MARK: Inheritance
public extension MTLCamera {
    
    override func didReceiveSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
    
        // Makes `MTLTexture`
        guard let texture = MTL.default.makeTexture(from: sampleBuffer, textureCache: self.textureCache) else { return }

        self.texture.swap(texture)
    }
}

// MARK: Protocol
extension MTLCamera: MTLImageSource {
    
    public var output: SignalProducer<MTLTexture, NoError> { return self.texture.producer.skipNil() }
}
