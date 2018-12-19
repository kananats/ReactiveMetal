//
//  OperationGroup.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import Result
import ReactiveSwift

// MARK: Main
/// Group of image operations
open class OperationGroup {
    
    /// Array of image operations
    /// output <-- operations[0] <-- operations[1] ... <-- operations[count - 1] <-- input
    private let operations: [ImageOperation]
    
    /// Init with operations
    /// Parameters to the left are closer to output
    /// Parameters to the right are closer to input
    init(_ operations: ImageOperation...) {
        self.operations = operations
        
        guard operations.count > 0 else { fatalError("At least one operation is required") }
        
        for index in 1 ..< operations.count {
            operations[index - 1] <-- operations[index]
        }
    }
}

// MARK: Protocol
extension OperationGroup: ImageOperation {
    
    public var output: SignalProducer<MTLTexture, NoError> {
        return self.operations.first!.output
    }
    
    public var sourceCount: Int {
        get { return self.operations.last!.sourceCount }
        set(value) { self.operations.last!.sourceCount = value }
    }
    
    public var maxSourceCount: Int { return self.operations.last!.maxSourceCount }
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> {
        return self.operations.last!.input(at: index)
    }
}
