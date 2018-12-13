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
    
    /// Cached pre-rendering texture
    private let inputs: [MutableProperty<MTLTexture?>]
    
    /// Cached post-rendering texture
    private let _output = MutableProperty<MTLTexture?>(nil)

    init(maxSourceCount: Int = 1, fragmentFunctionName: String) {
        self.pipelineState = MTL.default.makePipelineState(
            vertexFunctionName: "vertex_nofilter",
            fragmentFunctionName: fragmentFunctionName,
            vertexDescriptor: TextureMapVertex.descriptor
        )!
        
        self.vertexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.indices)!
        
        var inputs: [MutableProperty<MTLTexture?>] = []
        for _ in 0 ..< maxSourceCount { inputs.append(MutableProperty(nil)) }
        
        self.inputs = inputs
        
        super.init()
        
        SignalProducer.merge(self.inputs.map { $0.producer }).startWithValues { [weak self] _ in
            guard let `self` = self else { return }
   
            `self`.render { value in `self`._output.swap(value) }
        }
    }
}

extension Filter: MTLImageOperation {
    
    @objc open var maxSourceCount: Int { return self.inputs.count }
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> {
        return self.inputs[index].bindingTarget
    }
    
    public var output: SignalProducer<MTLTexture, NoError> {
        return self._output.producer.skipNil()
    }
    
    @objc open func texture(at index: Int) -> MTLTexture? { return self.inputs[index].value }
    
    @objc open var bufferCount: Int { return 0 }
    
    @objc open func buffer(at index: Int) -> MTLBuffer { fatalError("Array index out of bounds exception") }
}
