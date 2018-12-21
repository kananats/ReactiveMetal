//
//  BlendFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/21.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

// MARK: Main
/// Blend filter
public final class BlendFilter: Filter {
    
    /// Interpolant (range: 0 ~ 1) (reactive)
    public let interpolant: MutableProperty<Float>
    
    /// Initializes with initial interpolant
    public init!(interpolant: Float = 0.5) {
        self.interpolant = MutableProperty<Float>(interpolant)
        
        super.init(fragmentFunction: FragmentFunction(name: "fragment_blend", maxSourceCount: 2, params: interpolant))
        
        self.params(at: 0) <~ self.interpolant.map { $0 }
    }
}
