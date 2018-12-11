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
final class NoFilter {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    private let textureIn: MutableProperty<MTLTexture>
    private let textureOut: MutableProperty<MTLTexture>
    
    var texture: MTLTexture
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        self.pipelineState = MTLHelper.makePipelineState(
            vertexShader: "vertex_grayscale",
            fragmentShader: "fragment_grayscale",
            vertexDescriptor: TextureMapVertex.descriptor,
            device: device
        )!
        
        self.texture = MTLHelper.makeEmptyTexture(width: 720, height: 1280, device: device)!
        self.textureIn = MutableProperty<MTLTexture>(texture)
        self.textureOut = MutableProperty<MTLTexture>(texture)

        self.vertexBuffer = MTLHelper.makeBuffer(from: TextureMapVertex.vertices, device: device)!
        self.indexBuffer = MTLHelper.makeBuffer(from: TextureMapVertex.indices, device: device)!
        /*
        self.textureOut <~ self.textureIn.map { [weak self] in
            let image1 = UIImage(mtlTexture: $0)
            
            let value = self!.render(texture: $0)
            
            let image2 = UIImage(mtlTexture: value)
            print("sus")
            return value
        }
 */
    }
}

extension NoFilter: MTLImageOperation {
    var input: BindingTarget<MTLTexture> {
        return self.textureIn.bindingTarget
    }
    
    var output: SignalProducer<MTLTexture, NoError> {
        return self.textureOut.producer
    }
}
