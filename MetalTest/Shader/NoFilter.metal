//
//  Texture.metal
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

vertex OutputVertex vertex_nofilter(const InputVertex input [[stage_in]]) {
    OutputVertex output;
    output.position = input.position;
    output.texcoord = input.texcoord;
    return output;
};

fragment half4 fragment_nofilter(OutputVertex input [[stage_in]], texture2d<float> texture [[texture(0)]]) {
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, input.texcoord);
    return half4(color);
}
