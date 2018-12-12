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
    
    /// Index buffer
    var indexBuffer: MTLBuffer { get }
    
    /// Texture
    func texture(at index: Int) -> MTLTexture?
}

extension MTLImageTarget {
    
    /// Renders to texture
    func render(completion: @escaping (MTLTexture) -> ()) {
        guard self.texture(at: 0) != nil else { return }
        
        let output = MTL.default.makeEmptyTexture(width: 720, height: 1280)!
        
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = output
        descriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1)
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].loadAction = .clear
        
        let commandBuffer = MTL.default.commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        commandEncoder.setRenderPipelineState(self.pipelineState)
        
        commandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        for i in 0 ..< self.maxNumberOfSources {
            commandEncoder.setFragmentTexture(self.texture(at: i), index: i)
        }
        
        let test: [Float] = [0.3]
        let a = MTL.default.makeBuffer(from: test)
        commandEncoder.setFragmentBuffer(a, offset: 0, index: 0)
        
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
        
        for i in 0 ..< self.maxNumberOfSources {
            commandEncoder.setFragmentTexture(self.texture(at: i), index: i)
        }
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
