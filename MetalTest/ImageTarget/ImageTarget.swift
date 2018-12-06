//
//  ImageTarget.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

/// Protocol for image target
protocol ImageTarget {
    
    /// Input data type
    associatedtype Input
    
    /// Image input for binding
    var input: BindingTarget<Input> { get }
}
