//
//  ImageSource.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import Result
import ReactiveSwift

/// Protocol for image source
protocol ImageSource {
    associatedtype Output
    
    /// Image output (observable)
    var output: Signal<Output, NoError> { get }
}
