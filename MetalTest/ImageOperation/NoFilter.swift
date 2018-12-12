//
//  NoFilter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/10.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

/// Filter that passes the input to the output
open class NoFilter: NSObject {
    
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    public var numberOfSources = 0
    public let maxNumberOfSources = 1
    
    private let textureOut = MutableProperty<MTLTexture?>(nil)

    init(fragmentFunctionName: String) {
        self.pipelineState = MTL.default.makePipelineState(
            vertexFunctionName: "vertex_nofilter",
            fragmentFunctionName: fragmentFunctionName,
            vertexDescriptor: TextureMapVertex.descriptor
        )!
        
        self.vertexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.indices)!
    }
    
    public override convenience init() {
        self.init(fragmentFunctionName: "fragment_nofilter")
    }
}

extension NoFilter: MTLImageOperation {
    
    public var input: BindingTarget<MTLTexture> {
        return self.reactive.makeBindingTarget { `self`, value in
            `self`.render(texture: value) { value in
                `self`.textureOut.swap(value)
            }
        }
    }
    
    public var output: SignalProducer<MTLTexture, NoError> {
        return self.textureOut.producer.skipNil()
    }
}
