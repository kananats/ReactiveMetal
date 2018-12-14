//
//  RGBFilter.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

fragment half4 fragment_rgb(OutputVertex input [[stage_in]], texture2d<half> texture [[texture(0)]], device const float &red [[buffer(0)]], device const float &green [[buffer(1)]], device const float &blue [[buffer(2)]]) {
    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);

    half3 rgb = half3(red, green, blue);
    
    // component-wise multiplication
    half3 mixed = color.rgb * rgb;
    
    return half4(mixed, color.a);
}

