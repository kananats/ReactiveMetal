//
//  Vertex.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd

struct Vertex {
    
    /// position (x, y, z)
    var position: float3
    
    /// texture (u, v)
    var texture: float2
}

extension Vertex: VertexInfo {
    
    init() { self.init(position: float3(0, 0, 0), texture: float2(0, 0)) }
}
