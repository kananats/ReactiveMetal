//
//  MTLRenderView.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

// MARK: Main
/// View for rendering image output using metal enabled device
public final class RenderView: UIView {
    
    public var sourceCount = 0
    
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    private var texture: MTLTexture?

    /// Metal view
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: self.frame)
        
        view.device = MTL.default.device
        view.delegate = self
        
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        self.pipelineState = MTL.default.makePipelineState()!
        
        self.vertexBuffer = MTL.default.makeBuffer(from: DefaultVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: DefaultVertex.indices)!

        self.texture = MTL.default.makeEmptyTexture()!
        
        super.init(frame: frame)

        self.addSubview(self.metalView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK: Inheritance
extension RenderView {
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.metalView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

/// MARK: Protocol
extension RenderView: Renderer {

    public final var maxSourceCount: Int { return 1 }
    
    public final func input(at index: Int) -> BindingTarget<MTLTexture?> {
        guard index < self.maxSourceCount else { fatalError("Array index out of bounds exception") }
        
        return self.reactive.makeBindingTarget { `self`, value in
            guard let value = value else { return }
            `self`.texture = value
        }
    }

    final var textures: [MTLTexture?] { return [self.texture] }
    
    final var buffers: [MTLBuffer] { return [] }
}

extension RenderView: MTKViewDelegate {
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    public func draw(in view: MTKView) { self.render(in: view) }
}
