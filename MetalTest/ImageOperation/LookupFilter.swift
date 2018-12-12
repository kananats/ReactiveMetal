
//
//  LookupFilter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

public final class LookupFilter: Filter {
    
    let image = MTLImage(UIImage(named: "wallpaper")!)!
    
    public convenience init() {
        self.init(fragmentFunctionName: "fragment_lookup")
        
        (self, 1) <-- self.image
    }
}
