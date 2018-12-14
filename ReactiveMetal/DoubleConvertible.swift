//
//  DoubleConvertible.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import CoreGraphics

// MARK: Main
public protocol DoubleConvertible {
    
    /// `Double` representation
    var `double`: Double { get set }
}

// MARK: Extension
extension Int: DoubleConvertible {
    
    public var double: Double {
        get { return Double(self) }
        set(value) { self = Int(value) }
    }
}

extension Float: DoubleConvertible {
    
    public var double: Double {
        get { return Double(self) }
        set(value) { self = Float(value) }
    }
}

extension CGFloat: DoubleConvertible {
    
    public var double: Double {
        get { return Double(self) }
        set(value) { self = CGFloat(value) }
    }
}

extension Double: DoubleConvertible {
    
    public var double: Double {
        get { return self }
        set(value) { self = value }
    }
}
