//
//  HSVFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

// MARK: Main
/// Filter that transforms color in HSV color space
public final class HSVFilter: BasicFilter {
    
    /// Hue component adjustment (range: 0 ~ 1) (reactive)
    public let hue: MutableProperty<Float>
    
    /// Saturation component adjustment (range: 0 ~ 1) (reactive)
    public let saturation: MutableProperty<Float>
    
    /// Value component adjustment (range: 0 ~ 1) (reactive)
    public let `value`: MutableProperty<Float>
    
    /// Initializes with initial HSV adjustment
    public init!(hue: Float = 0, saturation: Float = 1, `value`: Float = 1) {
        
        self.hue = MutableProperty<Float>(hue)
        self.saturation = MutableProperty<Float>(saturation)
        self.`value` = MutableProperty<Float>(`value`)
        
        super.init(fragmentFunctionName: "fragment_hsv", params: [hue, saturation, `value`])
        
        self.params(at: 0) <~ self.hue.map { $0 }
        self.params(at: 1) <~ self.saturation.map { $0 }
        self.params(at: 2) <~ self.`value`.map { $0 }
    }
}
