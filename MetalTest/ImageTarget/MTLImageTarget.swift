//
//  MTLImageTarget.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/07.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

/// Protocol for image source using metal enabled device
protocol MTLImageTarget: ImageTarget, MTLEnabled where Data == MTLTexture { }
