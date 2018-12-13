//
//  Filter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/10.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

/// General superclass for image filter
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
    private let buffers: [MutableProperty<MTLBuffer>]

    /// Initializes a filter with maximum source(s) count, fragment function name, and parameters passed to the fragment function
    init(maxSourceCount: Int = 1, fragmentFunctionName: String, params: MTLBufferConvertible...) {
        // Initializes pipeline state
        self.pipelineState = MTL.default.makePipelineState(
            vertexFunctionName: "vertex_nofilter",
            fragmentFunctionName: fragmentFunctionName,
            vertexDescriptor: TextureMapVertex.descriptor
        )!
        
        // Initializes vertex and index buffers
        self.vertexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.indices)!
        
        // Initializes inputs
        var inputs: [MutableProperty<MTLTexture?>] = []
        for _ in 0 ..< maxSourceCount { inputs.append(MutableProperty<MTLTexture?>(nil)) }
        self.inputs = inputs
        
        // Initializes fragment buffers
        var buffers: [MutableProperty<MTLBuffer>] = []
        for param in params { buffers.append(MutableProperty<MTLBuffer>(param.buffer!)) }
        self.buffers = buffers
        
        super.init()
        
        // Reactively bind
        self.bind()
    }
}

// MARK: Protocol
extension Filter: MTLImageOperation {
    
    @objc open var maxSourceCount: Int { return self.inputs.count }
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> {
        return self.inputs[index].bindingTarget
    }
    
    final public var output: SignalProducer<MTLTexture, NoError> {
        return self._output.producer.skipNil()
    }
    
    final func texture(at index: Int) -> MTLTexture? { return self.inputs[index].value }
    
    final var bufferCount: Int { return self.buffers.count }
    
    final func buffer(at index: Int) -> MTLBuffer { return self.buffers[index].value }
}

// MARK: Public
public extension Filter {
    
    /// Shared dispatch queue for filter
    static let dispatchQueue = DispatchQueue(label: "com.donuts.ReactiveMetal.Filter")

    /// Parameters at specified index
    final func params(at index: Int) -> BindingTarget<MTLBufferConvertible> {
        return self.reactive.makeBindingTarget { `self`, value in
            LookupFilter.dispatchQueue.sync {
                `self`.buffers[index].swap(value.buffer!)
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