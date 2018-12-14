//
//  LookupFilter.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

fragment half4 fragment_lookup(OutputVertex input [[stage_in]], texture2d<half> texture0 [[texture(0)]], texture2d<half> texture1 [[texture(1)]], device const float &intensity [[buffer(0)]]) {

    constexpr sampler baseSampler;
    half4 base = texture0.sample(baseSampler, input.texcoord);
    
    half blueColor = base.b * 63.0;
    
    half2 quad1;
    quad1.y = floor(floor(blueColor) / 8.0);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);
    
    half2 quad2;
    quad2.y = floor(ceil(blueColor) / 8.0);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
    
    float2 texPos1;
    texPos1.x = (quad1.x * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * base.r);
    texPos1.y = (quad1.y * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * base.g);
    
    float2 texPos2;
    texPos2.x = (quad2.x * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * base.r);
    texPos2.y = (quad2.y * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * base.g);
    
    constexpr sampler quadSampler1;
    half4 newColor1 = texture1.sample(quadSampler1, texPos1);
    constexpr sampler quadSampler2;
    half4 newColor2 = texture1.sample(quadSampler2, texPos2);
    
    // frac(x) -> x - floor(x)
    half4 mixed = mix(newColor1, newColor2, fract(blueColor));
    
    return half4(mix(base, half4(mixed.rgb, base.w), half(intensity)));
}


