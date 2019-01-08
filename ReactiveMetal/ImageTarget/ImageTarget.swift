//
//  ImageTarget.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift

/// Protocol for image target
public protocol ImageTarget: AnyObject {
    
    /// Current number of sources
    var sourceCount: Int { get set }
    
    /// Maximum number of sources
    var maxSourceCount: Int { get }
    
    /// Operates with image inputs
    func input(at index: Int) -> BindingTarget<MTLTexture?>
}

public extension ImageTarget {
    
    /// For image binding
    /// target[index] <-- source
    subscript(index: Int) -> (ImageTarget, at: Int) {
        get { return (self, index) }
    }
}
