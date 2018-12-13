//
//  MTLImage.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

// MARK: Main
public class MTLImage {
    
    /// Current image (reactive)
    let image: MutableProperty<ImageConvertible>
    
    /// Initializes a `MTLImage` with image
    init(image: ImageConvertible) {
        self.image = MutableProperty<ImageConvertible>(image)
    }
}

// MARK: Protocol
extension MTLImage: MTLImageSource {

    public var output: SignalProducer<MTLTexture, NoError> {
        return self.image.producer.filterMap { $0._mtlTexture }
    }
}
