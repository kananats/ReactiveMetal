//
//  MTLImageTarget.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/07.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

/// Protocol for image target using metal enabled device
protocol MTLImageTarget: ImageTarget, MTLEnabled where Data == MTLTexture {
    
    /// Command queue of metal enabled device
    var commandQueue: MTLCommandQueue { get }
    
    /// Render pipeline state
    var pipelineState: MTLRenderPipelineState { get }
    
    /// Vertex buffer
    var vertexBuffer: MTLBuffer { get }
    
    /// Index buffer
    var indexBuffer: MTLBuffer { get }
}

extension MTLImageTarget {
    
    /// Renders to texture
    func render(texture: MTLTexture) -> MTLTexture {
        //let texture = MTLHelper.makeEmptyTexture(width: 720, height: 1280, device: self.device)!

        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = texture
        descriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1)
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].loadAction = .clear
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
        
        // Renders
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        commandBuffer.commit()
        
        return texture
    }
    
    /// Renders on `MTKView`
    func render(texture: MTLTexture, in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else { return }
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
       
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
