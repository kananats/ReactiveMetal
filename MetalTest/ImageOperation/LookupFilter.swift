
//
//  LookupFilter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit

public final class LookupFilter: Filter {
    
    let image = MTLImage(UIImage(named: "pretty")!.imageWith(newSize: CGSize(width: 720, height: 1280)))!
    
    public convenience init() {
        self.init(fragmentFunctionName: "fragment_lookup")
        
        (self, 1) <-- self.image
    }
    
    
}

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        
        return image
    }
}
