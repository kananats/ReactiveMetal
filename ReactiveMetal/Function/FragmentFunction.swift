//
//  FragmentFunction.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

// MARK: Main
/// Fragment function
public final class FragmentFunction {
    
    /// Fragment function
    public let function: MTLFunction
    
    /// Fragment buffers
    public let buffers: [MTLBuffer]
    
    /// Initializes with function name, and parameters
    public init!(name: String, params: MTLBufferConvertible...) {
        
        guard MTL.default != nil else { return nil }
        
        // Vertex function
        self.function = MTL.default.makeFunction(name: name)!
        
        // Fragment buffers
        self.buffers = params.map { $0.buffer! }
    }
}

// MARK: Public
public extension FragmentFunction {
    
    /// Default fragment function
    static let `default` = FragmentFunction(name: "fragment_default")!
}
