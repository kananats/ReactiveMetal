//
//  GrayscaleFilter.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/11.
//  Copyright © 2018 s.kananat. All rights reserved.
//

public final class GrayscaleFilter: Filter {

    public convenience init() {
        self.init(fragmentFunctionName: "fragment_grayscale")
    }
}
