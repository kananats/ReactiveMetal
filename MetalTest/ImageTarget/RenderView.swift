//
//  RenderView.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/06.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import MetalKit

/// View for rendering image output
class RenderView: UIView {
    
    /// Metal supported device
    private let device: MTLDevice
    
    /// Metal renderable
    private let renderable: Renderable
    
    /// Metal view
    private lazy var metalView: MTKView = {
        let view = MTKView(frame: frame)
        view.device = self.device
        view.delegate = self
        
        return view
    }()
    
    init(device: MTLDevice, frame: CGRect = .zero) {
        self.device = device
        self.renderable = Renderer(device: device)
        
        super.init(frame: frame)
        
        self.addSubview(self.metalView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RenderView: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) { self.renderable.render(in: view) }
}
