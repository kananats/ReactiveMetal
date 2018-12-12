//
//  LookupFilter.metal
//  MetalTest
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

fragment half4 fragment_lookup(OutputVertex input [[stage_in]], texture2d<float> texture0 [[texture(0)]], texture2d<float> texture1 [[texture(1)]]) {
    constexpr sampler defaultSampler;
    float4 color0 = texture0.sample(defaultSampler, input.texcoord);
    float4 color1 = texture1.sample(defaultSampler, input.texcoord);
    float4 color = (color0 + color1) / 2;
    return half4(color);
}


