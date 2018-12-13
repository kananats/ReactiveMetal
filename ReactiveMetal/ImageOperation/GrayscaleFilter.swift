//
//  GrayscaleFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/11.
//  Copyright © 2018 s.kananat. All rights reserved.
//

/// Filter that desaturates the color to grayscale
public final class GrayscaleFilter: Filter {

    public init() { super.init(fragmentFunctionName: "fragment_grayscale") }
}
