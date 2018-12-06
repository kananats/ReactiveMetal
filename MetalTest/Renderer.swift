//
//  Renderer.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

// MARK: Main
class Renderer: NSObject {

    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    public var texture: MTLTexture?

    private var _vertexBuffer: MTLBuffer!
    private var _indexBuffer: MTLBuffer!
    private var _pipelineState: MTLRenderPipelineState!
    
    init(device: MTLDevice) {

        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Unable to initialize `commandQueue`")
        }
        
        self.device = device
        self.commandQueue = commandQueue
        
        super.init()
        
        guard let vertexBuffer = self.makeBuffer(from: Data.vertices) else {
            fatalError("Unable to initialize `vertexBuffer`")
        }
        
        guard let indexBuffer = self.makeBuffer(from: Data.indices) else {
            fatalError("Unable to initialize `indexBuffer`")
        }
        
        guard let pipelineState = self.makePipelineState(vertexShader: "vertex_shader", fragmentShader: "fragment_shader") else {
            fatalError("Unable to initialize `pipelineState`")
        }

        self._vertexBuffer = vertexBuffer
        self._indexBuffer = indexBuffer
        
        self._pipelineState = pipelineState
    }
}

// MARK: Protocol
extension Renderer: Renderable {
    
    var vertexBuffer: MTLBuffer { return self._vertexBuffer }
    
    var indexBuffer: MTLBuffer { return self._indexBuffer }
    
    var pipelineState: MTLRenderPipelineState { return self._pipelineState }
    
    var vertexDescriptor: MTLVertexDescriptor { return Vertex.descriptor }

    var indexCount: Int { return Data.indices.count }
    
}
