//
//  NoFilter.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

// MARK: Main
/// Filter that passes the input to the output
public final class NoFilter: Filter {
    
    public init() { super.init(fragmentFunctionName: "fragment_texture_map") }
}
