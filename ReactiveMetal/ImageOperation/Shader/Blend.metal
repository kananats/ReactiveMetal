//
//  Blend.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/21.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Blend fragment shader
fragment half4 fragment_blend(FragmentInput input [[stage_in]], texture2d<half> texture0 [[texture(0)]], texture2d<half> texture1 [[texture(1)]], device const float &interpolant [[buffer(0)]]) {
    
    constexpr sampler defaultSampler;
    half4 color0 = texture0.sample(defaultSampler, input.texcoord);
    half4 color1 = texture1.sample(defaultSampler, input.texcoord);
    return mix(color0, color1, interpolant);
}
