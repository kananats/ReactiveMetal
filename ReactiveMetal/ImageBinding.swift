//
//  ImageBinding.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/17.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

precedencegroup BindingPrecedence {
    associativity: right
    
    higherThan: AssignmentPrecedence
}

infix operator <-- : BindingPrecedence

/// Forwards all values emitted from source to first input of the target
@discardableResult
public func <-- (target: ImageTarget, source: ImageSource) -> Disposable? {
    
    return (target, 0) <-- source
}

/// Forwards all values emitted from source to specific input of the target
@discardableResult
public func <-- (target: (ImageTarget, at: Int), source: ImageSource) -> Disposable? {
    
    let (target, index) = target
    guard index < target.maxSourceCount else { fatalError("Array index out of bounds exception") }
    
    target.sourceCount += 1
    
    guard target.sourceCount <= target.maxSourceCount else { fatalError("Number of sources of the target has exceeded the limit.") }
    
    let disposable = CompositeDisposable()
    
    disposable += target.input(at: index) <~ source.output
    disposable += { [weak target] in target?.sourceCount -= 1 }
    
    return disposable
}
