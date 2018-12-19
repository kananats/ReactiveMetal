//
//  BasicFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/19.
//  Copyright © 2018 s.kananat. All rights reserved.
//

// MARK: Main
/// Filter that operates on default vertex
open class BasicFilter: Filter<BasicVertex> {
    
    /// Initializes a basic filter with maximum source(s) count, fragment function name, and parameters passed to the fragment function
    public init!(maxSourceCount: Int = 1, fragmentFunctionName: String, params: [MTLBufferConvertible] = []) {
        super.init(maxSourceCount: maxSourceCount, vertices: BasicVertex.vertices, indices: BasicVertex.indices, fragmentFunctionName: fragmentFunctionName, params: params)
    }
}
