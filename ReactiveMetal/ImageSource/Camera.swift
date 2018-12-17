//
//  Camera.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import Result
import ReactiveSwift

// MARK: Main
/// Camera as image source
public final class Camera {

    /// Reference to AVCamera
    private let camera: AVCamera
    
    /// Texture cache
    private let textureCache: CVMetalTextureCache
    
    init?(position: AVCaptureDevice.Position = .back) {
        guard let camera = AVCamera(position: position),
            let textureCache = MTL.default.makeTextureCache()
            else { return nil }
        
        self.camera = camera
        self.textureCache = textureCache
    }
}

// MARK: Protocol
extension Camera: ImageSource {
    
    public var output: SignalProducer<MTLTexture, NoError> {
        
        return self.camera.sampleBuffer.filterMap { [weak self] value in
            guard let `self` = self,
                let texture = MTL.default.makeTexture(from: value, textureCache: `self`.textureCache)
                else { return nil }
            
            return texture
        }
    }
}
