//
//  Data.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd

class Data {
    
    static var vertices: [Vertex] = [
        Vertex(position: float3(-1, 1, 0), texture: float2(0, 0)),
        Vertex(position: float3(-1, -1, 0), texture: float2(0, 1)),
        Vertex(position: float3(1, -1, 0), texture: float2(1, 1)),
        Vertex(position: float3(1, 1, 0), texture: float2(1, 0))
    ]
    
    static var indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
}
