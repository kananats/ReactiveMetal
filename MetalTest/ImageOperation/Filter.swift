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
    
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    public var numberOfSources = 0
    
    /// Cached pre-rendering texture
    private var inputs: [MutableProperty<MTLTexture?>] = []
    
    /// Cached post-rendering texture
    private let _output = MutableProperty<MTLTexture?>(nil)

    init(maxNumberOfSources: Int = 1, fragmentFunctionName: String) {
        self.pipelineState = MTL.default.makePipelineState(
            vertexFunctionName: "vertex_nofilter",
            fragmentFunctionName: fragmentFunctionName,
            vertexDescriptor: TextureMapVertex.descriptor
        )!
        
        self.vertexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.indices)!
        
        for _ in 0 ... maxNumberOfSources { self.inputs.append(MutableProperty(nil)) }
        
        super.init()
        
        // TODO: fix
        self.inputs[0].producer.startWithValues { [weak self] value in
            guard let `self` = self, let value = value else { return }
            
            `self`.render(texture: value) { value in
                `self`._output.swap(value)
            }
        }
    }
}

extension Filter: MTLImageOperation {
    
    public var maxNumberOfSources: Int { return self.inputs.count }
    
    public var output: SignalProducer<MTLTexture, NoError> {
        return self._output.producer.skipNil()
    }
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> {
        return self.inputs[index].bindingTarget
    }
}
