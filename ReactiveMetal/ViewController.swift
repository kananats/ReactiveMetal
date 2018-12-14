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

    var source: MTLCamera!
    var filter: Filter!
    var target: MTLRenderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.source = MTLCamera(position: .front)!
        // let filter = LookupFilter(image: "pretty", intensity: 1)
        let filter = HSVFilter()

        self.filter = filter
        self.target = MTLRenderView(frame: self.view.frame)
        
        self.filter <-- self.source
        self.target <-- self.filter
        
        self.view.addSubview(self.target)
        
        Debugger.default.makeSilder(for: filter.hue, range: 0 ... 1)
        Debugger.default.makeSilder(for: filter.saturation, range: 0 ... 1)
        Debugger.default.makeSilder(for: filter.value, range: 0 ... 1)
    }
}

