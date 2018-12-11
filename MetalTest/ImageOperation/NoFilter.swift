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
final class NoFilter: NSObject {

    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    private let textureOut: MutableProperty<MTLTexture?>
    
    override init() {
        self.pipelineState = MTL.default.makePipelineState(
            vertexFunctionName: "vertex_nofilter",
            // TODO
            fragmentFunctionName: "fragment_grayscale",
            vertexDescriptor: TextureMapVertex.descriptor
        )!
        
        self.textureOut = MutableProperty<MTLTexture?>(nil)

        self.vertexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.vertices)!
        self.indexBuffer = MTL.default.makeBuffer(from: TextureMapVertex.indices)!
    }
}

extension NoFilter: MTLImageOperation {
    var input: BindingTarget<MTLTexture> {
        return self.reactive.makeBindingTarget { `self`, value in
            `self`.render(texture: value) { value in
                `self`.textureOut.swap(value)
            }
        }
    }
    
    var output: SignalProducer<MTLTexture, NoError> {
        return self.textureOut.producer.skipNil()
    }
}
