//
//  MTLRenderView.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift

// MARK: Main
/// View for rendering image output using metal enabled device
public final class RenderView: UIView {
    
    public var sourceCount = 0
    
    let pipelineState: MTLRenderPipelineState
    
    let vertexFunction: VertexFunction = .default
    let fragmentFunction: FragmentFunction = .default

    /// Metal view
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: self.frame)
        
        view.device = MTL.default.device
        view.delegate = self
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }()
    
    /// Initializes and returns a newly allocated view object with the specified frame rectangle
    public init!(_ frame: CGRect = .zero) {
        
        guard MTL.default != nil else { return nil }

        self.pipelineState = MTL.default.makePipelineState(vertexFunction: self.vertexFunction, fragmentFunction: self.fragmentFunction)!
        
        let texture = MTL.default.makeEmptyTexture()
        self.fragmentFunction.textures[0].swap(texture)
        
        super.init(frame: frame)

        self.addSubview(self.metalView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK: Protocol
extension RenderView: Renderer { }

extension RenderView: MTKViewDelegate {
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    public func draw(in view: MTKView) { self.render(in: view) }
}
