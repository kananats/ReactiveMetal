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
    
    /// Position
    private(set) public var position: float4
    
    /// Texture coordinates
    private(set) public var texcoord: float2
    
    /// Initializes with positions and texture coordinates
    public init(position: float4, texcoord: float2) {
        self.position = position
        self.texcoord = texcoord
    }
}

// MARK: Protocol
extension DefaultVertex: Vertex {

    public init() { self.init(position: float4(), texcoord: float2()) }
    
    public static let functionName = "vertex_default"
}

// MARK: Public
public extension DefaultVertex {
    
    /// All coordinate vertices
    static let vertices: [DefaultVertex] = [.topLeft, .bottomLeft, .bottomRight, .topRight]
}

// MARK: Private
private extension DefaultVertex {
    
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
