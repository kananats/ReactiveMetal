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
public class MTLRenderView: UIView {

    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    var texture: MTLTexture
    
    public var numberOfSources = 0
    public let maxNumberOfSources = 1
    
    /// Metal view
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: frame)
        view.device = MTL.default.device
        view.delegate = self
        
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        self.pipelineState = MTL.default.makePipelineState(
            vertexFunctionName: "vertex_nofilter",
            fragmentFunctionName: "fragment_nofilter",
            vertexDescriptor: TextureMapVertex.descriptor
        )!
        
        self.vertexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.indices)!

        self.texture = MTL.default.makeEmptyTexture(width: 720, height: 1280)!

        super.init(frame: frame)
        
        self.addSubview(self.metalView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK: Protocol
extension MTLRenderView: MTLImageTarget {
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> {
        guard index == 0 else { fatalError() }
        
        return self.reactive.makeBindingTarget { `self`, value in
            guard let value = value else { return }
            `self`.texture = value
        }
    }
}

extension MTLRenderView: MTKViewDelegate {
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    public func draw(in view: MTKView) {
        self.render(texture: self.texture, in: view)
    }
}
