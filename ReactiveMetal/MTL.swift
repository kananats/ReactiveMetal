//
//  MTL.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import MetalKit

// MARK: Main
/// Shared Metal resources
public final class MTL {
    
    /// Metal enabled device
    let device: MTLDevice
    
    /// Command queue of Metal enabled device
    let commandQueue: MTLCommandQueue
    
    /// Preferred texture size
    var preferredTextureSize = (width: 720, height: 1080)
    
    private init?() {
        guard let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
            else { return nil }
        
        self.device = device
        self.commandQueue = commandQueue
    }
}

// MARK: Public
public extension MTL {
    
    /// Shared instance
    static let `default`: MTL! = MTL()
    
    /// Makes pipeline state
    func makePipelineState(vertexFunctionName: String, fragmentFunctionName: String? = nil, vertexDescriptor: MTLVertexDescriptor? = nil) -> MTLRenderPipelineState? {
        
        let library = self.device.makeDefaultLibrary()!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // Vertex function
        guard let vertexFunction = library.makeFunction(name: vertexFunctionName) else {
            fatalError("vertexFunction `\(vertexFunctionName)` not found.")
        }
        
        pipelineDescriptor.vertexFunction = vertexFunction
        
        // Fragment function (optional)
        if let fragmentFunctionName = fragmentFunctionName {
            guard let fragmentFunction = library.makeFunction(name: fragmentFunctionName) else {
                fatalError("fragmentFunction `\(fragmentFunctionName)` not found.")
            }
            
            pipelineDescriptor.fragmentFunction = fragmentFunction
        }
        
        // Vertex descriptor (optional)
        if let vertexDescriptor = vertexDescriptor {
            pipelineDescriptor.vertexDescriptor = vertexDescriptor
        }
        
        return try? self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    /// Makes texture cache
    func makeTextureCache() -> CVMetalTextureCache? {
        var textureCache: CVMetalTextureCache?
        
        guard CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, self.device, nil, &textureCache) == kCVReturnSuccess else { return nil }
        
        return textureCache
    }
    
    /// Makes `MTLTexture` from `CMSampleBuffer`
    func makeTexture(from buffer: CMSampleBuffer, format: MTLPixelFormat = .bgra8Unorm, textureCache: CVMetalTextureCache) -> MTLTexture? {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)

        var metalTexture: CVMetalTexture?
        
        guard CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, format, width, height, 0, &metalTexture) == kCVReturnSuccess else { return nil }
        
        guard metalTexture != nil else { return nil }
        
        return CVMetalTextureGetTexture(metalTexture!)
    }

    /// Makes empty `MTLTexture`
    func makeEmptyTexture(width: Int, height: Int) -> MTLTexture? {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm, width: width, height: height, mipmapped: false)
        textureDescriptor.usage = [.renderTarget, .shaderRead]
        
        return self.device.makeTexture(descriptor: textureDescriptor)
    }
    
    /// Makes empty `MTLTexture` with the preferred texture size
    func makeEmptyTexture() -> MTLTexture? {
        return self.makeEmptyTexture(width: self.preferredTextureSize.width, height: self.preferredTextureSize.height)
    }
    
    /// Makes `MTLBuffer` from `Array<T>`
    func makeBuffer<T>(from array: [T]) -> MTLBuffer? {
        guard array.count > 0 else { return nil }
        
        return self.device.makeBuffer(bytes: array, length: array.count * MemoryLayout<T>.stride)
    }
}
