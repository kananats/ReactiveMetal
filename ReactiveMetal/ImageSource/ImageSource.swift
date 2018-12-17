//
//  ImageSource.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

// MARK: Main
/// Protocol for image source using metal enabled device
public protocol ImageSource: AnyObject {
    
    /// Image output (observable)
    var output: SignalProducer<MTLTexture, NoError> { get }
}
