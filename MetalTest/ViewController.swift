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
    
    var filter: Filter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.source = MTLCamera(position: .front)!
        self.filter = LookupFilter()
        self.target = MTLRenderView(frame: self.view.frame)
        
        self.filter <-- self.source
        self.target <-- self.filter
        
        self.view.addSubview(self.target)
    }
}

