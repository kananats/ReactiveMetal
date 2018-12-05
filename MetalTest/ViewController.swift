//
//  ViewController.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import MetalKit
import Metal

class ViewController: UIViewController {

    var metalView: MTKView!
    
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.renderer = Renderer()
        
        self.metalView = MTKView(frame: self.view.frame)
        self.metalView.delegate = self.renderer
        self.metalView.device = self.renderer.device

        self.view.addSubview(self.metalView)
    }
}

