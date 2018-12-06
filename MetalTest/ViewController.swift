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

    var camera: MetalCamera!
    
    var renderView: RenderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        
        self.camera = MetalCamera(device: device)
        self.renderView = RenderView(device: device, frame: self.view.frame)

        self.view.addSubview(self.renderView)
    }
}

