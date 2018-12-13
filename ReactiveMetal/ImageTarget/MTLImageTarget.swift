//
//  MTLImageTarget.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/07.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

/// Protocol for image target using metal enabled device
protocol MTLImageTarget: ImageTarget where Data == MTLTexture {

    /// Render pipeline state
    var pipelineState: MTLRenderPipelineState { get }
    
    /// Vertex buffer
    var vertexBuffer: MTLBuffer { get }
    
    /// Vertex index buffer
    var indexBuffer: MTLBuffer { get }
    
    /// Fragment texture(s)
    var textures: [MTLTexture?] { get }
    
    /// Fragment buffer(s)
    var buffers: [MTLBuffer] { get }
}

extension MTLImageTarget {
    
    /// Renders to texture
    func render(completion: @escaping (MTLTexture) -> ()) {
        guard self.textures[0] != nil else { return }
        
        let output = MTL.default.makeEmptyTexture()!
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = output
        descriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1)
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].loadAction = .clear
        
        self.render(descriptor: descriptor) { commandBuffer in
            commandBuffer.addCompletedHandler { _ in completion(output) }
        }
    }
    
    /// Renders on `MTKView`
    func render(in view: MTKView) {
        guard self.textures[0] != nil,
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        self.render(descriptor: descriptor) { commandBuffer in
            commandBuffer.present(drawable)
        }
    }
    
    /// Main implementation of `render`
    private func render(descriptor: MTLRenderPassDescriptor, completion: @escaping (MTLCommandBuffer) -> ()) {
        let commandBuffer = MTL.default.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        // Render pipeline state
        commandEncoder.setRenderPipelineState(self.pipelineState)
        
        // Vertex buffer
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        // Fragment texture(s)
        for (index, texture) in self.textures.enumerated() { commandEncoder.setFragmentTexture(texture, index: index) }
        
        // Fragment buffer(s)
        for (index, buffer) in self.buffers.enumerated() { commandEncoder.setFragmentBuffer(buffer, offset: 0, index: index) }
        
        // Draw indexed vertices
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        
        // Custom action
        completion(commandBuffer)
        
        commandBuffer.commit()
    }
}
