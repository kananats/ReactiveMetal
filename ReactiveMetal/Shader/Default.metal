//
//  Default.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Texture map vertex shader
vertex FragmentInput vertex_default(const VertexInput input [[stage_in]]) {
    FragmentInput fragmentInput;
    fragmentInput.position = input.position;
    fragmentInput.texcoord = input.texcoord;
    return fragmentInput;
};

/// Texture map fragment shader
fragment half4 fragment_default(FragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]]) {
    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);
    return color;
}
