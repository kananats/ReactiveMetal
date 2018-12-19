//
//  LuminanceFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/11.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

// MARK: Main
/// Filter that desaturates the color to grayscale
public final class LuminanceFilter: BasicFilter {

    /// Applying intensity (range: 0 ~ 1) (reactive)
    public let intensity: MutableProperty<Float>
    
    /// Initializes with initial intensity
    public init!(intensity: Float = 1) {
        self.intensity = MutableProperty<Float>(intensity)
        
        super.init(fragmentFunctionName: "fragment_luminance", params: [intensity])
        
        self.params(at: 0) <~ self.intensity.map { $0 }
    }
}
