//
//  RenderView.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

// MARK: Main
/// View for rendering image output
class RenderView: UIView {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    var pipelineState: MTLRenderPipelineState!
    
    /// Metal view
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: frame)
        view.device = self.device
        view.delegate = self
        
        return view
    }()
    
    /// Texture
    private var texture: MTLTexture!
    
    /// Vertex buffer
    private var vertexBuffer: MTLBuffer!
    
    /// Index buffer
    private var indexBuffer: MTLBuffer!
    
    init(device: MTLDevice, frame: CGRect = .zero) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        
        super.init(frame: frame)
        
        self.pipelineState = self.makePipelineState(vertexShader: "vertex_shader", fragmentShader: "fragment_shader", vertexDescriptor: TextureMapVertex.descriptor)!
        
        self.vertexBuffer = self.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = self.makeBuffer(from: TextureMapVertex.indices)!
        
        self.texture = self.makeTexture(from: UIImage(named: "wallpaper"))!
        
        self.addSubview(self.metalView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK: Protocol
extension RenderView: MetalRenderer {
    
    func encode(with encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        //encoder.setFragmentTexture(self.texture, index: 0)
        
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: TextureMapVertex.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
    }
}

extension RenderView: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) { self.render(in: view) }
}
