//
//  Renderer.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/07.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift

// MARK: Main
/// Protocol for image target using metal enabled device
protocol Renderer: ImageTarget {

    /// Render pipeline state
    var pipelineState: MTLRenderPipelineState { get }

    /// Vertex function
    var vertexFunction: VertexFunction { get }
    
    /// Fragment function
    var fragmentFunction: FragmentFunction { get }
}

// MARK: Public
extension Renderer {
    
    public var maxSourceCount: Int { return self.fragmentFunction.maxSourceCount }
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> { return self.fragmentFunction.textures[index].bindingTarget }
}

// MARK: Internal
internal extension Renderer {
    
    /// Renders to texture
    func render(completion: @escaping (MTLTexture) -> ()) {
        guard self.fragmentFunction.textures[0].value != nil else { return }
        
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
        guard self.fragmentFunction.textures[0].value != nil,
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
        commandEncoder.setVertexBuffer(self.vertexFunction.vertexBuffer, offset: 0, index: 0)
        
        // Fragment textures
        for (index, texture) in (self.fragmentFunction.textures.map { $0.value }.enumerated()) { commandEncoder.setFragmentTexture(texture, index: index) }
        
        // Fragment buffers
        for (index, buffer) in (self.fragmentFunction.buffers.map { $0.value }.enumerated()) { commandEncoder.setFragmentBuffer(buffer, offset: 0, index: index) }
        
        // Draw indexed vertices
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.vertexFunction.indexCount, indexType: .uint16, indexBuffer: self.vertexFunction.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.endEncoding()
        
        // Custom action
        completion(commandBuffer)
        
        commandBuffer.commit()
    }
}
