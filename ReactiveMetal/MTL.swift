//
//  MTL.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation

#if arch(i386) || arch(x86_64)
#else
import MetalKit
#endif

// MARK: Main
/// Shared Metal resources
public final class MTL {
    
    /// Metal enabled device
    public let device: MTLDevice
    
    /// Command queue of metal enabled device
    public let commandQueue: MTLCommandQueue
    
    /// Preferred texture size
    public var preferredTextureSize = (width: 720, height: 1080)
    
    /// Cached internal library
    private let internalLibrary: MTLLibrary
    
    /// Cached external library
    private let externalLibrary: MTLLibrary

    /// Initializes
    private init?() {
        guard let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
            else { return nil }
        
        self.device = device
        self.commandQueue = commandQueue
        
        let bundle = Bundle(for: MTL.self)
        guard let path = bundle.path(forResource: "default", ofType: "metallib"),
            let library = try? device.makeLibrary(filepath: path)
            else { return nil }
        
        self.internalLibrary = library
        self.externalLibrary = device.makeDefaultLibrary()!
    }
}

// MARK: Public
public extension MTL {
    
    /// Shared instance
    static let `default`: MTL! = MTL()
    
    /// Makes function. Internal library takes priority.
    func makeFunction(name: String) -> MTLFunction? {
        let internalFunction = self.internalLibrary.makeFunction(name: name)
        let externalFunction = self.externalLibrary.makeFunction(name: name)
        
        guard internalFunction == nil || externalFunction == nil || internalFunction === externalFunction else { fatalError("Function \(name) is already defined in `com.donuts.ReactiveMetal`") }
        
        return internalFunction ?? externalFunction
    }
    
    /// Makes pipeline state with vertex function and fragment function
    func makePipelineState(vertexFunction: VertexFunction = .default, fragmentFunction: FragmentFunction = .default) -> MTLRenderPipelineState? {

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // Vertex function
        pipelineDescriptor.vertexFunction = vertexFunction.function
        
        // Fragment function
        pipelineDescriptor.fragmentFunction = fragmentFunction.function
        
        // Vertex descriptor
        pipelineDescriptor.vertexDescriptor = vertexFunction.descriptor
        
        return try? self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
   
    #if arch(i386) || arch(x86_64)
    #else
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
    #endif
    
    /// Makes empty `MTLTexture` with specified texture width and height
    func makeEmptyTexture(width: Int, height: Int) -> MTLTexture? {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm, width: width, height: height, mipmapped: false)
        descriptor.usage = [.renderTarget, .shaderRead]
        
        return self.device.makeTexture(descriptor: descriptor)
    }
    
    /// Makes empty `MTLTexture` with specified texture size
    func makeEmptyTexture(size: Int) -> MTLTexture? {
        return self.makeEmptyTexture(width: size, height: size)
    }
    
    /// Makes empty `MTLTexture` with specified texture size
    func makeEmptyTexture(size: (Int, Int)) -> MTLTexture? {
        let (width, height) = size
        return self.makeEmptyTexture(width: width, height: height)
    }
    
    /// Makes empty `MTLTexture` with the preferred texture size
    func makeEmptyTexture() -> MTLTexture? {
        return self.makeEmptyTexture(size: self.preferredTextureSize)
    }
    
    /// Makes `MTLBuffer` from `Array<T>`
    func makeBuffer<T>(array: [T]) -> MTLBuffer? {
        guard array.count > 0 else { return nil }
        
        return self.device.makeBuffer(bytes: array, length: array.count * MemoryLayout<T>.stride)
    }
}
