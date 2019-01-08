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
    /// output <-- operations[n - 1] <-- ... <-- operations[1] <-- operations[0] <-- input
    private let operations: [ImageOperation]
    
    /// Init with operations
    /// Operations to the left is going to be processed first
    public init!(_ operations: ImageOperation?...) {
        
        guard !(operations.contains { $0 == nil }) else { return nil }
        
        self.operations = operations.map { $0! }
        
        guard self.operations.count > 0 else { fatalError("At least one operation is required") }
        
        for index in 0 ..< self.operations.count - 1 {
            self.operations[index + 1] <-- self.operations[index]
        }
    }
}

// MARK: Protocol
extension OperationGroup: ImageOperation {
    
    public var output: SignalProducer<MTLTexture, NoError> { return self.operations.last!.output }
    
    public var sourceCount: Int {
        get { return self.operations.first!.sourceCount }
        set(value) { self.operations.first!.sourceCount = value }
    }
    
    public var maxSourceCount: Int { return self.operations.first!.maxSourceCount }
    
    public func input(at index: Int) -> BindingTarget<MTLTexture?> { return self.operations.first!.input(at: index) }
}
