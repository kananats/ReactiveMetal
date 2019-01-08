//
//  MTLHeader.h
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/11.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#ifndef MTLHeader_h
#define MTLHeader_h

#include <metal_stdlib>
using namespace metal;

/// Vertex shader input
struct VertexInput
{
    float4 position     [[attribute(0)]];
    float2 texcoord     [[attribute(1)]];
};

/// Fragment shader input
struct FragmentInput
{
    float4 position     [[position]];
    float2 texcoord;
};

half3 rgb_to_hsv(half3 c);
half3 hsv_to_rgb(half3 c);

#endif /* MTLHeader_h */
