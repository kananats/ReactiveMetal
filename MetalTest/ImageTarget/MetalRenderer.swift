//
//  MetalRenderer.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

/// Renderer using metal supported device
protocol MetalRenderer: Renderer where View == MTKView {
    
    /// Metal supported device
    var device: MTLDevice { get }
    
    /// Command queue of metal supported device
    var commandQueue: MTLCommandQueue { get }
    
    /// Render pipeline state
    var pipelineState: MTLRenderPipelineState! { get }
    
    /// Encode
    func encode(with encoder: MTLRenderCommandEncoder)
}

extension MetalRenderer {
    
    /// Makes buffer from `Array<T>`
    func makeBuffer<T>(from array: [T]) -> MTLBuffer? {
        return self.device.makeBuffer(bytes: array, length: array.count * MemoryLayout<T>.stride)
    }
    
    /// Makes texture from `UIImage`
    func makeTexture(from image: UIImage?) -> MTLTexture? {
        guard let image = image?.cgImage else { return nil }
        
        let loader = MTKTextureLoader(device: self.device)
        
        var options: [MTKTextureLoader.Option: MTKTextureLoader.Origin] = [:]
        if #available(iOS 10.0, *) { options = [.origin: .bottomLeft] }
        
        return try? loader.newTexture(cgImage: image, options: options)
    }
    
    /// Makes pipeline state
    func makePipelineState(vertexShader: String, fragmentShader: String? = nil, vertexDescriptor: MTLVertexDescriptor? = nil) -> MTLRenderPipelineState? {
        
        let library = self.device.makeDefaultLibrary()!
        
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

        return try? self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func render(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
        self.encode(with: commandEncoder)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
