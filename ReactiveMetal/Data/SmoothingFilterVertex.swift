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
public struct SmoothingFilterVertex {
    var position: float4
    var texcoord: float2
    var size: float2
}

// MARK: Protocol
extension SmoothingFilterVertex: Vertex {
    
    public init() { self.init(position: float4(), texcoord: float2(), size: float2())}
    
    public static let functionName = "vertex_smoothing"
}
