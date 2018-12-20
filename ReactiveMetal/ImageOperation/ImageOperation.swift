//
//  ImageOperation.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/17.
//  Copyright © 2018 s.kananat. All rights reserved.
//

// MARK: Main
/// Protocol for image operation
public protocol ImageOperation: ImageSource, ImageTarget { }

// Main: Public
public extension ImageOperation {
    
    /// Returns the operation group containing two specified operations
    static func + (left: Self, right: ImageOperation?) -> OperationGroup {
        return OperationGroup(left, right)
    }
}

public extension Optional where Wrapped: ImageOperation {
    
    /// Returns the operation group containing two specified operations
    static func + (left: Optional, right: ImageOperation?) -> OperationGroup {
        return OperationGroup(left, right)
    }
}
