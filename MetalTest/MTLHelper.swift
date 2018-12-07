//
//  MTLHelper.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import MetalKit

// MARK: Main
public final class MTLHelper {
    
    private init() { }
}

// MARK: Public
public extension MTLHelper {
    /// Makes pipeline state
    static func makePipelineState(vertexShader: String, fragmentShader: String? = nil, vertexDescriptor: MTLVertexDescriptor? = nil, device: MTLDevice) -> MTLRenderPipelineState? {
        
        let library = device.makeDefaultLibrary()!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // Vertex function
        guard let vertexFunction = library.makeFunction(name: vertexShader) else {
            fatalError("vertexFunction `\(vertexShader)` not found.")
        }
        
        pipelineDescriptor.vertexFunction = vertexFunction
        
        // Fragment function (optional)
        if let fragmentShader = fragmentShader {
            guard let fragmentFunction = library.makeFunction(name: fragmentShader) else {
                fatalError("fragmentFunction `\(fragmentShader)` not found.")
            }
            
            pipelineDescriptor.fragmentFunction = fragmentFunction
        }
        
        // Vertex descriptor (optional)
        if let vertexDescriptor = vertexDescriptor {
            pipelineDescriptor.vertexDescriptor = vertexDescriptor
        }
        
        return try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    /// Makes texture cache
    static func makeTextureCache(device: MTLDevice) -> CVMetalTextureCache? {
        var textureCache: CVMetalTextureCache?
        
        guard CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache) == kCVReturnSuccess else { return nil }
        
        return textureCache
    }
    
    /// Makes `MTLTexture` from `CMSampleBuffer`
    static func makeTexture(from buffer: CMSampleBuffer, format: MTLPixelFormat = .bgra8Unorm, textureCache: CVMetalTextureCache, device: MTLDevice) -> MTLTexture? {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)

        var metalTexture: CVMetalTexture?
        
        guard CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, format, width, height, 0, &metalTexture) == kCVReturnSuccess else { return nil }
        
        guard metalTexture != nil else { return nil }
        
        return CVMetalTextureGetTexture(metalTexture!)
    }
    
    /// Makes `MTLTexture` from `UIImage`
    static func makeTexture(from image: UIImage?, device: MTLDevice) -> MTLTexture? {
        guard let image = image?.cgImage else { return nil }
        
        let loader = MTKTextureLoader(device: device)

        return try? loader.newTexture(cgImage: image)
    }
    
    /// Makes `MTLBuffer` from `Array<T>`
    static func makeBuffer<T>(from array: [T], device: MTLDevice) -> MTLBuffer? {
        guard array.count > 0 else { return nil }
            
        return device.makeBuffer(bytes: array, length: array.count * MemoryLayout<T>.stride)
    }
}
