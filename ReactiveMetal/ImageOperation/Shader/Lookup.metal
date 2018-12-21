//
//  Lookup.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/12.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Lookup fragment shader
fragment half4 fragment_lookup(FragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]], texture2d<half> lookupTexture [[texture(1)]], device const float &intensity [[buffer(0)]]) {

    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);
    
    half blue = color.b * 63.0;
    
    half2 quad1;
    quad1.y = floor(floor(blue) / 8.0);
    quad1.x = floor(blue) - (quad1.y * 8.0);
    
    half2 quad2;
    quad2.y = floor(ceil(blue) / 8.0);
    quad2.x = ceil(blue) - (quad2.y * 8.0);
    
    float2 texPos1;
    texPos1.x = (quad1.x * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * color.r);
    texPos1.y = (quad1.y * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * color.g);
    
    float2 texPos2;
    texPos2.x = (quad2.x * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * color.r);
    texPos2.y = (quad2.y * 0.125) + 0.5 / 512.0 + ((0.125 - 1.0 / 512.0) * color.g);
    
    constexpr sampler quadSampler1;
    half4 newColor1 = lookupTexture.sample(quadSampler1, texPos1);
    constexpr sampler quadSampler2;
    half4 newColor2 = lookupTexture.sample(quadSampler2, texPos2);
    
    // frac(x) -> x - floor(x)
    half4 mixed = mix(newColor1, newColor2, fract(blue));
    
    return half4(mix(color, half4(mixed.rgb, color.w), half(intensity)));
}
