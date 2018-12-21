//
//  SmoothingFilterVertex.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd

// MARK: Main
/// Unidirectional smoothing filter vertex
struct SmoothingFilterVertex {
    
    /// Position
    var position: float4
    
    /// Texture coordinates
    var texcoord: float2
    
    /// Texture size
    var size: float2
}

// MARK: Protocol
extension SmoothingFilterVertex: Vertex {
    
    public init() { self.init(position: float4(), texcoord: float2(), size: float2())}
    
    public static let functionName = "vertex_smoothing"
}

// MARK: Internal
internal extension SmoothingFilterVertex {
    
    static func vertices(for size: float2) -> [SmoothingFilterVertex] {
        return [
            SmoothingFilterVertex(position: float4(-1, 1, 0, 1), texcoord: float2(0, 0), size: size),
            SmoothingFilterVertex(position: float4(-1, -1, 0, 1), texcoord: float2(0, 1), size: size),
            SmoothingFilterVertex(position: float4(1, -1, 0, 1), texcoord: float2(1, 1), size: size),
            SmoothingFilterVertex(position: float4(1, 1, 0, 1), texcoord: float2(1, 0), size: size)
        ]
    }
}
