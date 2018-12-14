//
//  MTLImageOperation.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/10.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

// MARK: Main
/// Protocol for image processing operation using metal enabled device
protocol MTLImageOperation: MTLImageSource, MTLImageTarget { }
