//
//  GrayscaleFilter.metal
//  MetalTest
//
//  Created by s.kananat on 2018/12/10.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

fragment half4 fragment_grayscale(OutputVertex input [[stage_in]], texture2d<float> texture [[texture(0)]]) {
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, input.texcoord);
    float gray = (color.r + color.g + color.b) / 3;
    return half4(gray, gray, gray, color.a);
}
