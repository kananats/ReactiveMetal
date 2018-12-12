//
//  ImageSource.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import Result
import ReactiveSwift

precedencegroup BindingPrecedence {
    associativity: right
    
    higherThan: AssignmentPrecedence
}

infix operator <-- : BindingPrecedence

// MARK: Main
/// Protocol for image source
public protocol ImageSource {
    
    /// Output data type
    associatedtype Data
    
    /// Image output (observable)
    var output: SignalProducer<Data, NoError> { get }
}
