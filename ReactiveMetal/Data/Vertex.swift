//
//  Vertex.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

// MARK: Main
/// A protocol for vertex struct
public protocol Vertex {
    
    /// Init without any parameter
    init()
    
    /// Corresponding vertex shader function name
    static var functionName: String { get }
}

// MARK: Internal
internal extension Vertex {
    
    /// Makes descriptor for the vertex
    static var descriptor: MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        
        var offset = 0
        
        let mirror = Mirror(reflecting: Self())
        
        for (index, element) in mirror.children.enumerated() {
            let (_, value) = element
            
            var format: MTLVertexFormat = .invalid
            
            var stride = 0
            switch value {
            
            case is float2:     format = .float2;       stride = MemoryLayout<float2>.stride
            case is float3:     format = .float3;       stride = MemoryLayout<float3>.stride
            case is float4:     format = .float4;       stride = MemoryLayout<float4>.stride
            default:            break
            }
            
            guard format != .invalid else { fatalError("Unsupported type found: \(type(of: value))") }
            
            descriptor.attributes[index].format = format
            descriptor.attributes[index].offset = offset
            descriptor.attributes[index].bufferIndex = 0
            
            offset += stride
        }
        
        descriptor.layouts[0].stride = MemoryLayout<Self>.stride
        
        return descriptor
    }
}
