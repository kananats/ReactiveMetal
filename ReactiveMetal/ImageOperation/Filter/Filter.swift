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
    
    public var sourceCount = 0
    
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    /// Pre-rendering textures (reactive)
    private let inputs: [MutableProperty<MTLTexture?>]
    
    /// Post-rendering texture (reactive)
    private let _output = MutableProperty<MTLTexture?>(nil)

    /// Fragment buffers
    private let _buffers: [MutableProperty<MTLBuffer>]
    
    /// Initializes with maximum source count, vertex function, and fragment function
    public init!(maxSourceCount: Int = 1, vertexFunction: VertexFunction = .default, fragmentFunction: FragmentFunction = .default) {

        guard MTL.default != nil else { return nil }
        
        // Pipeline state
        self.pipelineState = MTL.default.makePipelineState(vertexFunction: vertexFunction, fragmentFunction: fragmentFunction)!
        
        // Vertex buffers
        self.vertexBuffer = vertexFunction.vertexBuffer
        
        // Index buffers
        self.indexBuffer = vertexFunction.indexBuffer
        
        // Initializes inputs
        var inputs: [MutableProperty<MTLTexture?>] = []
        for _ in 0 ..< maxSourceCount { inputs.append(MutableProperty<MTLTexture?>(nil)) }
        self.inputs = inputs
        
        // Fragment buffers
        self._buffers = fragmentFunction.buffers.map { MutableProperty<MTLBuffer>($0) }
        
        super.init()
        
        // Reactively bind
        self.bind()
    }
}

// MARK: Protocol
extension Filter: ImageOperation {
    
    public final var output: SignalProducer<MTLTexture, NoError> {
        return self._output.producer.skipNil()
    }
    
    public final var maxSourceCount: Int { return self.inputs.count }
    
    public final func input(at index: Int) -> BindingTarget<MTLTexture?> { return self.inputs[index].bindingTarget }
}

extension Filter: Renderer {

    final var textures: [MTLTexture?] { return self.inputs.map { $0.value } }
    
    final var buffers: [MTLBuffer] { return self._buffers.map { $0.value } }
}

// MARK: Public
public extension Filter {

    /// Parameters at specified index
    final func params(at index: Int) -> BindingTarget<MTLBufferConvertible> {
        return self.reactive.makeBindingTarget { `self`, value in
            `self`.dispatchQueue.sync {
                `self`._buffers[index].swap(value.buffer!)
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
        
        disposable += SignalProducer.merge(self.inputs.map { $0.producer }).startWithValues { [weak self] _ in
            guard let `self` = self else { return }
            
            `self`.render { value in `self`._output.swap(value) }
        }
        
        return disposable
    }
}
