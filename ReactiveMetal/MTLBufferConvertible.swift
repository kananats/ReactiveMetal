//
//  MTLBufferConvertible.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/13.
//  Copyright © 2018 s.kananat. All rights reserved.
//


import MetalKit

// MARK: Main
/// A type that can be converted to `MTLBuffer`
public protocol MTLBufferConvertible {
    
    /// Converts to `MTLBuffer`
    var buffer: MTLBuffer? { get }
}

// MARK: Private
private extension MTLBufferConvertible {
    
    /// Makes `MTLBuffer` from `[Float]`
    func makeBuffer(from array: [Float]) -> MTLBuffer? {
        return MTL.default.makeBuffer(from: array)
    }
}

// MARK: Extension
extension Float: MTLBufferConvertible {
    public var buffer: MTLBuffer? { return self.makeBuffer(from: [self]) }
}

extension Array: MTLBufferConvertible where Element == Float {
    public var buffer: MTLBuffer? { return self.makeBuffer(from: self) }
}
