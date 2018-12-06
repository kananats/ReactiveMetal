//
//  Renderer.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit
import ReactiveSwift

/// Renderer
protocol Renderer {
    
    /// Type of the view
    associatedtype View: UIView
    
    /// Renders on the view
    func render(in view: View)
}
