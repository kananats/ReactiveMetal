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
    
    let vertexFunction: VertexFunction
    let fragmentFunction: FragmentFunction

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
    
    public final var output: SignalProducer<MTLTexture, NoError> {
        return self._output.producer.skipNil()
    }
    
}

extension Filter: Renderer { }

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
        
        disposable += SignalProducer.merge(self.fragmentFunction.textures.map { $0.producer }).startWithValues { [weak self] _ in
            guard let `self` = self else { return }
            
            `self`.render { value in `self`._output.swap(value) }
        }
        
        return disposable
    }
}
