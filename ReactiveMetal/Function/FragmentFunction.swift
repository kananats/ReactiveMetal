//
//  FragmentFunction.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift

// MARK: Main
/// Fragment function
public final class FragmentFunction {
    
    /// Fragment function
    let function: MTLFunction
    
    /// Maximum source count
    let maxSourceCount: Int
    
    /// Fragment textures (reactive)
    let textures: [MutableProperty<MTLTexture?>]
    
    /// Fragment buffers (reactive)
    let buffers: [MutableProperty<MTLBuffer>]
    
    /// Initializes with function name, and parameters
    public init!(name: String, maxSourceCount: Int = 1, params: MTLBufferConvertible...) {
        
        guard MTL.default != nil else { return nil }
        
        // Fragment function
        self.function = MTL.default.makeFunction(name: name)!
        
        // Maximum source count
        self.maxSourceCount = maxSourceCount
        
        // Fragment textures
        var textures: [MutableProperty<MTLTexture?>] = []
        for _ in 0 ..< maxSourceCount { textures.append(MutableProperty<MTLTexture?>(nil)) }
        self.textures = textures
        
        // Fragment buffers
        self.buffers = params.map { MutableProperty<MTLBuffer>($0.buffer!) }
    }
}

// MARK: Public
public extension FragmentFunction {
    
    /// Default fragment function
    static var `default`: FragmentFunction { return FragmentFunction(name: "fragment_default")! }
}
