//
//  MTLRenderer.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

/// Renderer using metal enabled device
protocol MTLRenderer: Renderer, MTLImageTarget where View == MTKView {
    
    /// Command queue of metal enabled device
    var commandQueue: MTLCommandQueue { get }
    
    /// Render pipeline state
    var pipelineState: MTLRenderPipelineState! { get }
    
    /// Encode
    func encode(with encoder: MTLRenderCommandEncoder)
}

extension MTLRenderer {
    
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
