//
//  SmoothingFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import simd
import CoreGraphics

// MARK: Main
/// Unidirectional smoothing filter direction
enum SmoothingFilterDirection {
    case vertical
    case horizontal
}

// MARK: Internal
internal extension SmoothingFilterDirection {
    
    /// Make vertices
    func makeVertices(inputTextureSize: CGSize) -> [SmoothingFilterVertex] {
        var width: Float = 0
        var height: Float = 0
        
        switch self {
        case .vertical:     height = 1.0 / Float(inputTextureSize.height)
        case .horizontal:   width = 1.0 / Float(inputTextureSize.width)
        }
        
        let size = float2(width, height)
        return [
            SmoothingFilterVertex(position: float4(-1, 1, 0, 1), texcoord: float2(0, 0), size: size),
            SmoothingFilterVertex(position: float4(-1, -1, 0, 1), texcoord: float2(0, 1), size: size),
            SmoothingFilterVertex(position: float4(1, -1, 0, 1), texcoord: float2(1, 1), size: size),
            SmoothingFilterVertex(position: float4(1, 1, 0, 1), texcoord: float2(1, 0), size: size)
        ]
    }
}

/// Unidirectional smoothing filter
public class SmoothingFilter: Filter {
    
    // private let direction: SmoothingFilterDirection
    
    fileprivate init(direction: SmoothingFilterDirection) {
        
        let size = MTL.default.preferredTextureSize
        let vertices = direction.makeVertices(inputTextureSize: CGSize(width: size.width, height: size.height))
        
        super.init(vertexFunction: VertexFunction(vertices: vertices), fragmentFunction: FragmentFunction(name: "fragment_smoothing"))
    }
}

/// Horizontal smoothing filter
public final class HorizontalSmoothingFilter: SmoothingFilter {
    
    /// Initializes
    public init() { super.init(direction: .horizontal) }
}

/// Vertical smoothing filter
public final class VerticalSmoothingFilter: SmoothingFilter {
    
    /// Initializes
    public init() { super.init(direction: .vertical) }
}
