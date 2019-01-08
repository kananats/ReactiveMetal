//
//  Brightness.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2019/01/08.
//  Copyright © 2019 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Brightness constant
constant half3 kBrightness = half3(0.299, 0.587, 0.114);

fragment half4 fragment_brightness(FragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]], device const float &intensity [[buffer(0)]]) {
    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);
    half brightness = clamp(dot(color.rgb, kBrightness), half(0.0), half(1.0));
    
    // mix(x, y, a) -> x * (1 - a) + y * a
    half3 mixed = mix(color.rgb * brightness, half3(brightness), 0.25);
    
    return half4(mixed * (1.0 - brightness), color.a);
}
