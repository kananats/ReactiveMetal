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
    
    /// color (r, g, b, a)
    var color: float4
}

extension Vertex: VertexInfo {
    
    init() {
        self.init(position: float3(0, 0, 0), color: float4(0, 0, 0, 0))
    }
}
