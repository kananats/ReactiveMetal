//
//  Filter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/10.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

// MARK: Main
/// Base class for an image filter
open class Filter: NSObject {
    
    /// Dispatch queue for filter
    private let dispatchQueue = DispatchQueue(label: "com.donuts.ReactiveMetal.Filter")
    
    public final var sourceCount = 0
    
    final let pipelineState: MTLRenderPipelineState
    
    final let vertexFunction: VertexFunction
    final let fragmentFunction: FragmentFunction

    /// Output texture (reactive)
    private let _output = MutableProperty<MTLTexture?>(nil)

    /// Initializes with maximum source count, vertex function, and fragment function
    public init!(vertexFunction: VertexFunction = .default, fragmentFunction: FragmentFunction = .default) {

        guard MTL.default != nil else { return nil }
        
        // Vertex function
        self.vertexFunction = vertexFunction
        
        // Fragment function
        self.fragmentFunction = fragmentFunction
        
        // Pipeline state
        self.pipelineState = MTL.default.makePipelineState(vertexFunction: vertexFunction, fragmentFunction: fragmentFunction)!
        
        super.init()
        
        // Reactively bind
        self.bind()
    }
}

// MARK: Protocol
extension Filter: ImageOperation {
    
    public final var output: SignalProducer<MTLTexture, NoError> { return self._output.producer.skipNil() }
}

extension Filter: Renderer {
    
    @objc open func encode(with encoder: MTLRenderCommandEncoder) {
        
        // Vertex buffer
        encoder.setVertexBuffer(self.vertexFunction.vertexBuffer, offset: 0, index: 0)
        
        // Fragment textures
        for (index, texture) in (self.fragmentFunction.textures.map { $0.value }.enumerated()) { encoder.setFragmentTexture(texture, index: index) }
        
        // Fragment buffers
        for (index, buffer) in (self.fragmentFunction.buffers.map { $0.value }.enumerated()) { encoder.setFragmentBuffer(buffer, offset: 0, index: index) }
        
        // Draw indexed vertices
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: self.vertexFunction.indexCount, indexType: .uint16, indexBuffer: self.vertexFunction.indexBuffer, indexBufferOffset: 0)
    }
}

// MARK: Public
public extension Filter {

    /// Parameters at specified index
    final func params(at index: Int) -> BindingTarget<MTLBufferConvertible> {
        return self.reactive.makeBindingTarget { `self`, value in
            `self`.dispatchQueue.sync {
                `self`.fragmentFunction.buffers[index].swap(value.buffer!)
            }
        }
    }
}

// MARK: Private
private extension Filter {
    
    /// Bind
    @discardableResult
    func bind() -> Disposable? {
        let disposable = CompositeDisposable()
        
        disposable += self.textureReceived.observeValues { [weak self] _, _ in
            guard let `self` = self else { return }
            `self`.render { value in `self`._output.swap(value) }
        }

        return disposable
    }
}
