//
//  Filter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/17.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import Foundation

/// Base class for image filter
open class Filter: Operation<DefaultVertex> {
    
    override init(maxSourceCount: Int = 1, vertices: [DefaultVertex] = DefaultVertex.vertices, indices: [UInt16] = DefaultVertex.indices, fragmentFunctionName: String, params: [MTLBufferConvertible] = []) {
        
        super.init(vertices: vertices, indices: indices, fragmentFunctionName: fragmentFunctionName, params: params)
    }
}
