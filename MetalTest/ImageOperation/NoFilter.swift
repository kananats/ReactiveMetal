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
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    private let textureOut: MutableProperty<MTLTexture?>
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        self.pipelineState = MTLHelper.makePipelineState(
            vertexShader: "vertex_nofilter",
            // TODO
            fragmentShader: "fragment_grayscale",
            vertexDescriptor: TextureMapVertex.descriptor,
            device: device
        )!
        
        self.textureOut = MutableProperty<MTLTexture?>(nil)

        self.vertexBuffer = MTLHelper.makeBuffer(from: TextureMapVertex.vertices, device: device)!
        self.indexBuffer = MTLHelper.makeBuffer(from: TextureMapVertex.indices, device: device)!
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
