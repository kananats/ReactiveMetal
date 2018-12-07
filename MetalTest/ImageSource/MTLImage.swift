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
class MTLImage {
    
    let device: MTLDevice
    
    /// Pipe for observing `MTLTexture` output
    private let pipe = Signal<MTLTexture, NoError>.pipe()
    
    init?(_ image: UIImage?, device: MTLDevice) {
        self.device = device
        
        guard let texture = MTLHelper.makeTexture(from: image, device: device) else { return nil }
        
        self.pipe.input.send(value: texture)
    }
}

// MARK: Protocol
extension MTLImage: MTLImageSource {

    var output: Signal<MTLTexture, NoError> { return self.pipe.output }
}

