//
//  BrightnessFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2019/01/08.
//  Copyright © 2019 s.kananat. All rights reserved.
//

import ReactiveSwift

// MARK: Main
/// Filter that adjusts the brightness
public final class BrightnessFilter: Filter {
    
    /// Applied intensity (range: 0 ~ 1) (reactive)
    public let intensity: MutableProperty<Float>
    
    /// Initializes with initial intensity
    public init!(intensity: Float = 1) {
        self.intensity = MutableProperty<Float>(intensity)
        
        super.init(fragmentFunction: FragmentFunction(name: "fragment_brightness", params: intensity))
        
        self.params(at: 0) <~ self.intensity.map { $0 }
    }
}
