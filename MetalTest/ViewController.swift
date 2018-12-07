//
//  ViewController.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import MetalKit
import ReactiveSwift

class ViewController: UIViewController {

    var source: MTLCamera!
    var target: MTLRenderView!
    
    //var camera: MTLCamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        
        self.source = MTLCamera(device: device)!
        //let source = MTLImage(UIImage(named: "wallpaper"), device: device)!
        self.target = MTLRenderView(device: device, frame: self.view.frame)
        
        self.target <-- source
        
        self.view.addSubview(self.target)
    }
}

