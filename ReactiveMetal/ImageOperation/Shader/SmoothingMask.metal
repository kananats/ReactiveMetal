//
//  SmoothingMask.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

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

half hv2opacity(half2 hv)
{
    float op = mix((hv.y - 0.2) / 0.1, 1.0, step(0.3, float(hv.y)));
    
    float temp1 = mix(op, op * (0.2 - hv.x) / 0.03, step(0.17, float(hv.x)));
    float temp2 = mix(temp1, 0, step(0.2, float(hv.x)));
    float temp3 = mix(temp2, op * (hv.x - 0.88) / 0.03, step(0.88, float(hv.x)));
    float temp4 = mix(temp3, op, step(0.88, float(hv.x)));
    
    return mix(0, temp4, step(0.2, float(hv.y)));
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
fragment half4 fragment_smoothing_mask(SmoothingMaskFragmentInput input             [[stage_in]], texture2d<half> texture [[texture(0)]], texture2d<half> inputTexture [[texture(1)]], device const float &intensity [[buffer(0)]])
{
    constexpr sampler defaultSampler;
    constexpr sampler defaultSampler2;

    half4 color = texture.sample(defaultSampler, input.texcoord);
    // return color;
    
    // TODO: here
    
    //half2 hv = rgb_to_hsv(color.rgb).xz;

    //float op = mix(0, intensity * hv2opacity(hv), step(1, step(0.2, float(hv.y)) + step(0.88, float(hv.x)) * step(float(hv.x), 0.17) + step(0, intensity)));

    half4 newColor = inputTexture.sample(defaultSampler2, input.texcoord);

    return mix(color, newColor, 0.5);
}
