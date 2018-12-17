//
//  ViewController.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import MetalKit
import ReactiveSwift

class ViewController: UIViewController {

    var source: Camera!
    var filter: ImageOperation!
    var target: RenderView!
    
    var debuggers: [Debugger] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.source = Camera(position: .front)!
        
        let hsv = HSVFilter()

        self.target = RenderView(frame: self.view.frame)
        
        let rgb = RGBFilter()

        self.filter = OperationGroup(hsv, rgb)
    
        self.filter <-- self.source
        self.target <-- self.filter
        
        self.view.addSubview(self.target)
    }
}

