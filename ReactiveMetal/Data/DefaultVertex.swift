//
//  DefaultVertex.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd

// MARK: Main
/// Vertex for mapping texture coordinates to render quad
public struct DefaultVertex {
    
    /// position (x, y, z, w)
    var position: float4
    
    /// texture coordinates (u, v)
    var texcoord: float2
}

// MARK: Protocol
extension DefaultVertex: Vertex {
    
    public static let functionName = "vertex_default"

    public init() { self.init(position: float4(), texcoord: float2()) }
}

// MARK: Public
public extension DefaultVertex {
    
    /// All coordinate vertices
    public static let vertices: [DefaultVertex] = [.topLeft, .bottomLeft, .bottomRight, .topRight]
    
    /// All coordinate indices
    public static let indices: [UInt16] = [0, 1, 2, 2, 3, 0]
}

// MARK: Private
extension DefaultVertex {
    
    /// Bottom left coordinate
    static let bottomLeft = DefaultVertex(position: float4(-1, 1, 0, 1), texcoord: float2(0, 0))
    
    /// Top left coordinate
    static let topLeft = DefaultVertex(position: float4(-1, -1, 0, 1), texcoord: float2(0, 1))
    
    /// Top right coordinate
    static let topRight = DefaultVertex(position: float4(1, -1, 0, 1), texcoord: float2(1, 1))

    /// Bottom right coordinate
    static let bottomRight =
        DefaultVertex(position: float4(1, 1, 0, 1), texcoord: float2(1, 0))
}
