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

public extension ImageSource {
    
    /// Forwards all values emitted from source to first input of the target
    @discardableResult
    static func <-- <Target: ImageTarget>(target: Target, source: Self) -> Disposable? where Self.Data == Target.Data {
        
        return (target, 0) <-- source
    }
    
    /// Forwards all values emitted from source to specific input of the target
    @discardableResult
    static func <-- <Target: ImageTarget>(target: (Target, Int), source: Self) -> Disposable? where Self.Data == Target.Data {
        
        let (target, index) = target
        target.numberOfSources += 1
        
        guard target.numberOfSources <= target.maxNumberOfSources else { fatalError("Number of sources of the target had exceeded the limit.") }
        
        let disposable = CompositeDisposable()
        
        disposable += target.input(at: index) <~ source.output
        disposable += { [weak target] in target?.numberOfSources -= 1 }
        
        return disposable
    }
}
