//
//  Extension.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import MetalKit

final class MetalHelper {
    
    static let device: MTLDevice! = MTLCreateSystemDefaultDevice()
    
    private static let textureCache = MetalHelper.makeTextureCache()
    
    static func makeTextureCache() -> CVMetalTextureCache? {
        var textureCache: CVMetalTextureCache?
        guard CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, self.device, nil, &textureCache) == kCVReturnSuccess else { return nil }
        
        return textureCache
    }
    
    static func makeTexture(from buffer: CMSampleBuffer, format: MTLPixelFormat = .bgra8Unorm) -> MTLTexture? {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer),
            let textureCache = MetalHelper.textureCache
            else { return nil }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        var imageTexture: CVMetalTexture?
        
        guard CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, format, width, height, 0, &imageTexture) == kCVReturnSuccess else { return nil }
        
        guard let unwrappedImageTexture = imageTexture,
            let texture = CVMetalTextureGetTexture(unwrappedImageTexture)
            else { return nil }
        
        return texture
    }
}
