//
//  RGBFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

// MARK: Main
/// Filter that transforms color in RGB color space
public final class RGBFilter: BasicFilter {
    
    /// Red component adjustment (range: 0 ~ 1) (reactive)
    public let red: MutableProperty<Float>
    
    /// Green component adjustment (range: 0 ~ 1) (reactive)
    public let green: MutableProperty<Float>
    
    /// Blue component adjustment (range: 0 ~ 1) (reactive)
    public let blue: MutableProperty<Float>
    
    /// Initializes with initial RGB adjustment
    public init!(red: Float = 1, green: Float = 1, blue: Float = 1) {
        
        self.red = MutableProperty<Float>(red)
        self.green = MutableProperty<Float>(green)
        self.blue = MutableProperty<Float>(blue)
        
        super.init(fragmentFunctionName: "fragment_rgb", params: [red, green, blue])
        
        self.params(at: 0) <~ self.red.map { $0 }
        self.params(at: 1) <~ self.green.map { $0 }
        self.params(at: 2) <~ self.blue.map { $0 }
    }
}
