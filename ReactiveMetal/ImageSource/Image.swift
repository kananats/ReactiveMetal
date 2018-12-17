//
//  MTLImage.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

// MARK: Main
/// Static image as image source
public class Image {
    
    /// Current image (reactive)
    let image: MutableProperty<ImageConvertible>
    
    /// Initializes a `MTLImage` with image
    init(image: ImageConvertible) {
        self.image = MutableProperty<ImageConvertible>(image)
    }
}

// MARK: Protocol
extension Image: ImageSource {

    public var output: SignalProducer<MTLTexture, NoError> {
        return self.image.producer.filterMap { $0._mtlTexture }
    }
}
