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
open class Camera {

    /// Reference to AVCamera
    private let camera: AVCamera
    
    #if arch(i386) || arch(x86_64)
    #else
    /// Texture cache
    private let textureCache: CVMetalTextureCache
    #endif
    
    /// Init with a camera position
    public init!(position: AVCaptureDevice.Position = .front) {
        #if arch(i386) || arch(x86_64)
            return nil
        #else
            guard MTL.default != nil,
            let textureCache = MTL.default.makeTextureCache(),
            let camera = AVCamera(position: position)
            else { return nil }
        
            self.camera = camera
            self.textureCache = textureCache
        #endif
    }
}

// MARK: Protocol
extension Camera: ImageSource {
    
    public final var output: SignalProducer<MTLTexture, NoError> {
        
        return self.camera.sampleBuffer.filterMap { [weak self] value in
            #if arch(i386) || arch(x86_64)
                return nil
            #else
                guard let `self` = self,
                    let texture = MTL.default.makeTexture(from: value, textureCache: `self`.textureCache)
                else { return nil }
            
                return texture
            #endif
        }
    }
}

// MARK: Public
public extension Camera {
    
    // Starts the capture session
    final func startCapture() { self.camera.startCapture() }
    
    // Stops the capture session
    final func stopCapture() { self.camera.stopCapture() }
    
    /// Video orientation (reactive)
    final var orientation: MutableProperty<AVCaptureVideoOrientation> { return self.camera.orientation }
}
