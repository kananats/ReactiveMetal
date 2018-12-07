//
//  MTLEnabled.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

protocol MTLEnabled {
    
    /// Metal enabled device
    var device: MTLDevice { get }
}
