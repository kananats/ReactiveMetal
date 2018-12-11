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
    
    /// Latest `MTLTexture` (observable)
    private let texture: MutableProperty<MTLTexture>
    
    init?(_ image: UIImage?, device: MTLDevice) {
        self.device = device
        
        guard let texture = MTLHelper.makeTexture(from: image, device: device) else { return nil }
        
        self.texture = MutableProperty(texture)
    }
}

// MARK: Protocol
extension MTLImage: MTLImageSource {

    var output: SignalProducer<MTLTexture, NoError> { return self.texture.producer }
}

