//
//  ImageTarget.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

/// Protocol for image target
public protocol ImageTarget: AnyObject {
    
    /// Input data type
    associatedtype Data
    
    /// Current number of sources
    var sourceCount: Int { get set }
    
    /// Maximum number of sources
    var maxSourceCount: Int { get }
    
    /// Operates with image inputs
    func input(at index: Int) -> BindingTarget<Data?>
}
