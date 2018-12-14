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
/// Base class for image filter
open class Filter: NSObject {
    
    public var sourceCount = 0
    
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    /// Pre-rendering texture(s) (reactive)
    private let inputs: [MutableProperty<MTLTexture?>]
    
    /// Post-rendering texture (reactive)
    private let _output = MutableProperty<MTLTexture?>(nil)

    /// Fragment buffer(s)
    private let _buffers: [MutableProperty<MTLBuffer>]
    
    /// Initializes a filter with specified vertex type, maximum source(s) count, fragment function name, and parameters passed to the fragment function
    init<Vertex: MTLVertex>(vertex: Vertex.Type, maxSourceCount: Int = 1, fragmentFunctionName: String, params: MTLBufferConvertible...) {

        // Initializes pipeline state
        self.pipelineState = MTL.default.makePipelineState(
            vertex: vertex,
            fragmentFunctionName: fragmentFunctionName
        )!
        
        // Initializes vertex and index buffers
        self.vertexBuffer = MTL.default.makeBuffer(from: Vertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: Vertex.indices)!
        
        // Initializes inputs
        var inputs: [MutableProperty<MTLTexture?>] = []
        for _ in 0 ..< maxSourceCount { inputs.append(MutableProperty<MTLTexture?>(nil)) }
        self.inputs = inputs
        
        // Initializes fragment buffers
        var buffers: [MutableProperty<MTLBuffer>] = []
        for param in params { buffers.append(MutableProperty<MTLBuffer>(param.buffer!)) }
        self._buffers = buffers
        
        super.init()
        
        // Reactively bind
        self.bind()
    }
    
    /// Initializes a filter with maximum source(s) count, fragment function name, and parameters passed to the fragment function
    init(maxSourceCount: Int = 1, fragmentFunctionName: String, params: MTLBufferConvertible...) {
        
        // Initializes pipeline state
        self.pipelineState = MTL.default.makePipelineState(
            vertex: DefaultVertex.self,
            fragmentFunctionName: fragmentFunctionName
        )!
        
        // Initializes vertex and index buffers
        self.vertexBuffer = MTL.default.makeBuffer(from: DefaultVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: DefaultVertex.indices)!
        
        // Initializes inputs
        var inputs: [MutableProperty<MTLTexture?>] = []
        for _ in 0 ..< maxSourceCount { inputs.append(MutableProperty<MTLTexture?>(nil)) }
        self.inputs = inputs
        
        // Initializes fragment buffers
        var buffers: [MutableProperty<MTLBuffer>] = []
        for param in params { buffers.append(MutableProperty<MTLBuffer>(param.buffer!)) }
        self._buffers = buffers
        
        super.init()
        
        // Reactively bind
        self.bind()
    }
}

// MARK: Protocol
extension Filter: MTLImageOperation {
    
    public final var maxSourceCount: Int { return self.inputs.count }
    
    public final func input(at index: Int) -> BindingTarget<MTLTexture?> { return self.inputs[index].bindingTarget }
    
    public final var output: SignalProducer<MTLTexture, NoError> {
        return self._output.producer.skipNil()
    }
    
    final var textures: [MTLTexture?] { return self.inputs.map { $0.value } }
    
    final var buffers: [MTLBuffer] { return self._buffers.map { $0.value } }
}

// MARK: Public
public extension Filter {
    
    /// Shared dispatch queue for filter
    static let dispatchQueue = DispatchQueue(label: "com.donuts.ReactiveMetal.Filter")

    /// Parameters at specified index
    final func params(at index: Int) -> BindingTarget<MTLBufferConvertible> {
        return self.reactive.makeBindingTarget { `self`, value in
            Filter.dispatchQueue.sync {
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
