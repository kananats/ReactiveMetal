
//
//  LookupFilter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

public final class LookupFilter: Filter {
    
    let image = MTLImage(UIImage(named: "wallpaper")!)!
    
    var buffer: MTLBuffer
    
    public init(intensity: Float = 0.88) {
        let a: [Float] = [1]
        self.buffer = MTL.default.makeBuffer(from: a)!
        
        super.init(maxSourceCount: 2, fragmentFunctionName: "fragment_lookup")
        
        (self, 1) <-- self.image
    }
}

extension LookupFilter {
    override public var bufferCount: Int {
        return 1
    }
    
    @objc override public func buffer(at index: Int) -> MTLBuffer {
        return self.buffer
    }
}
