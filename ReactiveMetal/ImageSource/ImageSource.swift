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

precedencegroup BindingPrecedence {
    associativity: right
    
    higherThan: AssignmentPrecedence
}

infix operator <-- : BindingPrecedence

// MARK: Main
/// Protocol for image source using metal enabled device
public protocol ImageSource: AnyObject {
    
    /// Image output (observable)
    var output: SignalProducer<MTLTexture, NoError> { get }
}

// MARK: Public
public extension ImageSource {
    
    /// Forwards all values emitted from source to first input of the target
    @discardableResult
    static func <-- <Target: ImageTarget>(target: Target, source: Self) -> Disposable? {
        
        return (target, 0) <-- source
    }
    
    /// Forwards all values emitted from source to specific input of the target
    @discardableResult
    static func <-- <Target: ImageTarget>(target: (Target, at: Int), source: Self) -> Disposable? {
        
        let (target, index) = target
        guard index < target.maxSourceCount else { fatalError("Array index out of bounds exception") }
        
        target.sourceCount += 1
        
        guard target.sourceCount <= target.maxSourceCount else { fatalError("Number of sources of the target has exceeded the limit.") }
        
        let disposable = CompositeDisposable()
        
        disposable += target.input(at: index) <~ source.output
        disposable += { [weak target] in target?.sourceCount -= 1 }
        
        return disposable
    }
}
