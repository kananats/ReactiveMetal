//
//  MTLImageTarget.swift
//  MetalTest
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
    
    /// Fragment texture at specified index
    func texture(at index: Int) -> MTLTexture?
    
    /// Number of fragment buffer
    var bufferCount: Int { get }
    
    /// Fragment buffer at specified index
    func buffer(at index: Int) -> MTLBuffer
}

extension MTLImageTarget {
    
    /// Renders to texture
    func render(completion: @escaping (MTLTexture) -> ()) {
        guard self.texture(at: 0) != nil else { return }
        
        let output = MTL.default.makeEmptyTexture()!
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = output
        descriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1)
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].loadAction = .clear
        
        let commandBuffer = MTL.default.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
        
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        for i in 0 ..< self.maxSourceCount {
            commandEncoder.setFragmentTexture(self.texture(at: i), index: i)
        }

        for i in 0 ..< self.bufferCount {
            commandEncoder.setFragmentBuffer(self.buffer(at: i), offset: 0, index: i)
        }

        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        
        commandBuffer.addCompletedHandler { _ in completion(output) }
        commandBuffer.commit()
    }
    
    /// Renders on `MTKView`
    func render(in view: MTKView) {
        guard self.texture(at: 0) != nil,
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        let commandBuffer = MTL.default.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
       
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        for i in 0 ..< self.maxSourceCount {
            commandEncoder.setFragmentTexture(self.texture(at: i), index: i)
        }
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
