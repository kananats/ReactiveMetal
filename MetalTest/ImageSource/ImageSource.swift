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
protocol ImageSource {
    
    /// Output data type
    associatedtype Data
    
    /// Image output (observable)
    var output: Signal<Data, NoError> { get }
}

// MARK: Internal
extension ImageSource {
    
    /// Forwards all values emitted from source to target
    @discardableResult
    static func <-- <Target: ImageTarget>(target: Target, source: Self) -> Disposable? where Self.Data == Target.Data {
        return target.input <~ source.output
    }
}
