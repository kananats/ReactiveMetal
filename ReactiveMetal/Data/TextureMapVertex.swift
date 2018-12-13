//
//  TextureMapVertex.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd

// MARK: Main
/// Vertex for mapping texture coordinates to render view
struct TextureMapVertex {
    
    /// position (x, y, z, w)
    var position: float4
    
    /// texture coordinates (u, v)
    var texture: float2
}

// MARK: Protocol
extension TextureMapVertex: Vertex {
    
    init() { self.init(position: float4(), texture: float2()) }
}

// MARK: Internal
extension TextureMapVertex {
    
    /// All coordinate vertices
    static let vertices: [TextureMapVertex] = [.topLeft, .bottomLeft, .bottomRight, .topRight]
    
    /// All coordinate indices
    static let indices: [UInt16] = [0, 1, 2, 2, 3, 0]
}

// MARK: Private
extension TextureMapVertex {
    
    /// Bottom left coordinate
    static let bottomLeft = TextureMapVertex(position: float4(-1, 1, 0, 1), texture: float2(0, 0))
    
    /// Top left coordinate
    static let topLeft = TextureMapVertex(position: float4(-1, -1, 0, 1), texture: float2(0, 1))
    
    /// Top right coordinate
    static let topRight = TextureMapVertex(position: float4(1, -1, 0, 1), texture: float2(1, 1))

    /// Bottom right coordinate
    static let bottomRight =
        TextureMapVertex(position: float4(1, 1, 0, 1), texture: float2(1, 0))
}
