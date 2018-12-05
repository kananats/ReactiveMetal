//
//  Renderable.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import Metal
import MetalKit

protocol Renderable {
    
    /// Metal device
    /// Make strong reference to this
    var device: MTLDevice { get }
    
    /// Command queue of metal device
    /// Make strong reference to this
    var commandQueue: MTLCommandQueue { get }
    
    /// Render pipeline state
    var pipelineState: MTLRenderPipelineState { get }
    
    /// Vertex buffer
    var vertexBuffer: MTLBuffer { get }
    
    /// Vertex descriptor
    var vertexDescriptor: MTLVertexDescriptor { get }
    
    /// Index buffer
    var indexBuffer: MTLBuffer { get }
    
    /// Index count
    var indexCount: Int { get }
}

extension Renderable {
    
    /// Make buffer from array
    func makeBuffer<T>(from array: [T]) -> MTLBuffer? {
        return self.device.makeBuffer(bytes: array, length: array.count * MemoryLayout<T>.stride)
    }

    /// Make pipeline state
    func makePipelineState(vertexShader: String, fragmentShader: String? = nil) -> MTLRenderPipelineState? {
        
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
    
        // Vertex descriptor
        pipelineDescriptor.vertexDescriptor = self.vertexDescriptor
        
        return try? self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    /// Renders in a `MTKView`
    func render(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indexCount, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
