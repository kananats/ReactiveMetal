//
//  BasicVertex.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd

// MARK: Main
/// Vertex for mapping texture coordinates to render quad
public struct BasicVertex {
    
    /// position (x, y, z, w)
    var position: float4
    
    /// texture coordinates (u, v)
    var texcoord: float2
}

// MARK: Protocol
extension BasicVertex: Vertex {
    
    public static let functionName = "vertex_basic"

    public init() { self.init(position: float4(), texcoord: float2()) }
}

// MARK: Public
public extension BasicVertex {
    
    /// All coordinate vertices
    static let vertices: [BasicVertex] = [.topLeft, .bottomLeft, .bottomRight, .topRight]
    
    /// All coordinate indices
    static let indices: [UInt16] = [0, 1, 2, 2, 3, 0]
}

// MARK: Private
private extension BasicVertex {
    
    /// Bottom left coordinate
    static let bottomLeft = BasicVertex(position: float4(-1, 1, 0, 1), texcoord: float2(0, 0))
    
    /// Top left coordinate
    static let topLeft = BasicVertex(position: float4(-1, -1, 0, 1), texcoord: float2(0, 1))
    
    /// Top right coordinate
    static let topRight = BasicVertex(position: float4(1, -1, 0, 1), texcoord: float2(1, 1))

    /// Bottom right coordinate
    static let bottomRight =
        BasicVertex(position: float4(1, 1, 0, 1), texcoord: float2(1, 0))
}
