//
//  ImageTarget.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import ReactiveSwift

/// Protocol for image target
public protocol ImageTarget: AnyObject {
    
    /// Input data type
    associatedtype Data
    
    /// Current number of sources
    var numberOfSources: Int { get set }
    
    /// Maximum number of sources
    var maxNumberOfSources: Int { get }
    
    /// Operates with image input
    var input: BindingTarget<Data> { get }
}

// MARK: Public
public extension ImageTarget {
    
    /// Forwards all values emitted from source to target
    @discardableResult
    static func <-- <Source: ImageSource>(target: Self, source: Source) -> Disposable? where Self.Data == Source.Data {
        
        target.numberOfSources += 1
        
        guard target.numberOfSources <= target.maxNumberOfSources else { fatalError("Number of sources of the target had exceeded the limit.") }
        
        let disposable = CompositeDisposable()
        
        disposable += target.input <~ source.output
        disposable += { [weak target] in
            target?.numberOfSources -= 1
        }

        return disposable
    }
}
