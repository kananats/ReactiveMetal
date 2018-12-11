//
//  MTLHeader.h
//  MetalTest
//
//  Created by s.kananat on 2018/12/11.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#ifndef MTLHeader_h
#define MTLHeader_h

#include <metal_stdlib>
using namespace metal;

struct InputVertex
{
    float4 position     [[attribute(0)]];
    float2 texcoord     [[attribute(1)]];
};

struct OutputVertex
{
    float4 position     [[position]];
    float2 texcoord;
};

#endif /* MTLHeader_h */