//
//  VertexFunction.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

// MARK: Main
/// Vertex function
public final class VertexFunction {
    
    /// Vertex function
    let function: MTLFunction
    
    /// Vertex buffer
    let vertexBuffer: MTLBuffer
    
    /// Index buffer
    let indexBuffer: MTLBuffer
    
    /// Vertex descriptor
    let descriptor: MTLVertexDescriptor
    
    /// Initializes with function name, vertices, and indices
    public init!<V: Vertex>(vertices: [V], indices: [UInt16]) {
        
        guard MTL.default != nil else { return nil }
        
        // Vertex function
        self.function = MTL.default.makeFunction(name: V.functionName)!
        
        // Vertex buffer
        self.vertexBuffer = MTL.default.makeBuffer(array: vertices)!
        
        // Index buffer
        self.indexBuffer = MTL.default.makeBuffer(array: indices)!
        
        // Vertex descriptor
        self.descriptor = V.descriptor
    }
    
    /// Initializes with function name, vertices, and default indices
    public convenience init!<V: Vertex>(vertices: [V]) {
        self.init(vertices: vertices, indices: VertexFunction.indices)
    }
}

// MARK: Public
public extension VertexFunction {
    
    /// Default vertex function
    static let `default` = VertexFunction(vertices: DefaultVertex.vertices)!
}

// MARK: Private
private extension VertexFunction {
    
    /// Default indices
    static let indices: [UInt16] = [0, 1, 2, 2, 3, 0]
}
