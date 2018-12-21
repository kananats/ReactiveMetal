//
//  SmoothingMaskFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd
import ReactiveSwift

/// Smoothing mask filter
public final class SmoothingMaskFilter: Filter {
    
    /// Applying intensity (range: 0 ~ 1) (reactive)
    public let intensity: MutableProperty<Float>
    
    /// Initializes with initial intensity
    public init!(intensity: Float = 0) {
        self.intensity = MutableProperty<Float>(intensity)
        
        // TODO: fix
        let size = MTL.default.preferredTextureSize
        let size2 = float2(Float(size.width), Float(size.height))
        
        let vertices = [
            SmoothingFilterVertex(position: float4(-1, 1, 0, 1), texcoord: float2(0, 0), size: size2),
            SmoothingFilterVertex(position: float4(-1, -1, 0, 1), texcoord: float2(0, 1), size: size2),
            SmoothingFilterVertex(position: float4(1, -1, 0, 1), texcoord: float2(1, 1), size: size2),
            SmoothingFilterVertex(position: float4(1, 1, 0, 1), texcoord: float2(1, 0), size: size2)
        ]

        super.init(vertexFunction: VertexFunction(vertices: vertices),
            fragmentFunction: FragmentFunction(name: "fragment_smoothing_mask", maxSourceCount: 2, params: intensity))
        
        self.params(at: 0) <~ self.intensity.map { $0 }
    }
}
