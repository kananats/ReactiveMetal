
//
//  LookupFilter.swift
//  ReactiveMetal
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
    private let _image: Image
    
    /// Applying intensity (range: 0 ~ 1) (reactive)
    public let intensity: MutableProperty<Float>
    
    /// Initializes with image and initial intensity
    public init!(image: ImageConvertible, intensity: Float = 0.88) {

        self._image = Image(image)
        self.intensity = MutableProperty<Float>(intensity)
        
        super.init(fragmentFunction: FragmentFunction(name: "fragment_lookup", maxSourceCount: 2, params: intensity))

        (self, at: 1) <-- self._image

        self.params(at: 0) <~ self.intensity.map { $0 }
    }
}

// MARK: Public
public extension LookupFilter {
    
    /// Current image (reactive)
    var image: MutableProperty<ImageConvertible> { return self._image.image }
}
