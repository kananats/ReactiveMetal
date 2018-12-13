
//
//  LookupFilter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveSwift

// MARK: Main
/// Lookup filter
public final class LookupFilter: Filter {
    
    /// `MTLImage` as lookup source
    private let _image: MTLImage
    
    /// Applying intensity (range: 0 ~ 1)
    let intensity: MutableProperty<Float>
    
    /// Initializes with image and intensity
    public init(image: ImageConvertible, intensity: Float = 0.88) {

        self._image = MTLImage(image: image)
        self.intensity = MutableProperty<Float>(intensity)
        
        super.init(maxSourceCount: 2, fragmentFunctionName: "fragment_lookup", params: intensity)
        
        (self, 1) <-- self._image

        self.params(at: 0) <~ self.intensity.map { $0 }
    }
}

public extension LookupFilter {
    
    /// Current image (reactive)
    var image: MutableProperty<ImageConvertible> { return self._image.image }
}
