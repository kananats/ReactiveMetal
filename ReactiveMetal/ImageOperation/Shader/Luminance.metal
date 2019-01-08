//
//  Luminance.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/10.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Luminance constant from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham
constant half3 kLuminance = half3(0.2125, 0.7154, 0.0721);

fragment half4 fragment_luminance(FragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]], device const float &intensity [[buffer(0)]]) {
    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);
    half luminance = dot(color.rgb, kLuminance);
    
    // mix(x, y, a) -> x * (1 - a) + y * a
    half3 mixed = mix(color.rgb, half3(luminance), intensity);
    
    return half4(mixed, color.a);
}
