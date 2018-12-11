//
//  MTLRenderView.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift
import ReactiveCocoa

// MARK: Main
/// View for rendering image output
class MTLRenderView: UIView {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    var texture: MTLTexture
    
    /// Metal view
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: frame)
        
        view.device = self.device
        view.delegate = self
        
        return view
    }()
    
    init(device: MTLDevice, frame: CGRect = .zero) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        self.pipelineState = MTLHelper.makePipelineState(
            vertexShader: "vertex_nofilter",
            fragmentShader: "fragment_grayscale",
            vertexDescriptor: TextureMapVertex.descriptor,
            device: device
        )!
        
        self.vertexBuffer = MTLHelper.makeBuffer(from: TextureMapVertex.vertices, device: device)!
        self.indexBuffer = MTLHelper.makeBuffer(from: TextureMapVertex.indices, device: device)!

        self.texture = MTLHelper.makeEmptyTexture(width: 720, height: 1280, device: device)!

        super.init(frame: frame)
        
        self.addSubview(self.metalView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK: Protocol
extension MTLRenderView: MTLImageTarget {
    
    var input: BindingTarget<MTLTexture> {
        return self.reactive.makeBindingTarget { `self`, value in
            // print("view got input")
            `self`.texture = value
        }
    }
}

extension MTLRenderView: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) {
        self.render(texture: self.texture, in: view)
    }
}
