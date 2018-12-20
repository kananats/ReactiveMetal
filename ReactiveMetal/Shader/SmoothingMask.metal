//
//  SmoothingMask.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//
/*
#include "MTLHeader.h"

struct SmoothingMaskVertexInput
{
    float4 position     [[attribute(0)]];
    float2 texcoord     [[attribute(1)]];
    float2 size         [[attribute(2)]];
};

struct SmoothingMaskFragmentInput
{
    float4 position             [[position]];
    float2 texcoord;
    float2 texcoordBicubic;
    float2 scale;
};

// TODO: fix this shit
half hv2opacity(half2 hv)
{
    if(hv.y < 0.2) {
        return 0.0;
    } else {
        half op = 1.0;
        if (hv.y < 0.3) {
            op = (hv.y - 0.2) / 0.1;
        }
        
        if (hv.x >= 0.91 || hv.x <= 0.17) {
            return op;
        } else if(hv.x >= 0.88) {
            return op * (hv.x - 0.88) / 0.03;
        } else if(hv.x <= 0.2) {
            return op * (0.2 - hv.x) / 0.03;
        } else {
            return 0.0;
        }
    }
}

half4 cubic(half x)
{
    half x2 = x * x;
    half x3 = x2 * x;
    half4 w;
    w.x = -x3 + 3.0 * x2 - 3.0 *x + 1.0;
    w.y = 3.0 * x3 - 6.0 * x2;
    w.z = -3.0 * x3 + 3.0 * x2 + 3.0 * x + 1.0;
    w.w = x3;
    return w / 6.0;
}

/// Smoothing mask vertex shader
vertex SmoothingMaskFragmentInput vertex_smoothing_mask(SmoothingMaskVertexInput input [[stage_in]])
{
    SmoothingMaskFragmentInput output;
    output.position = input.position;
    output.texcoord = input.texcoord;
    output.texcoordBicubic = input.texcoord.xy * input.size;
    output.scale = 1.0 / input.size;
    return output;
}

/// Smoothing mask fragment shader
fragment half4 fragment_smoothing_mask(SmoothingMaskFragmentInput input             [[stage_in]], texture2d<half> originalTexture [[texture(0)]], texture2d<half> inputTexture [[texture(1)]], device float* parameters [[buffer(0)]])
{
    constexpr sampler colorSampler;
    half4 inputColor = originalTexture.sample(colorSampler, input.texcoord);
    half2 hv = rgb_to_hsv(inputColor.rgb).xz;
    float opacity = parameters[0];
    
    if (hv.y <= 0.2 || (hv.x < 0.88 && hv.x > 0.17) || opacity == 0) {
        return inputColor;
    } else {
        half op = opacity * hv2opacity(hv);
        half4 targetColor = inputTexture.sample(colorSampler, input.texcoord);
        return mix(inputColor, targetColor, op);
    }
}

*/
