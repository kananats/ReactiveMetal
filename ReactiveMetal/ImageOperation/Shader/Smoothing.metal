//
//  Smoothing.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Smoothing vertex input
struct SmoothingVertexInput
{
    float4 position     [[attribute(0)]];
    float2 texcoord     [[attribute(1)]];
    float2 size         [[attribute(2)]];
};

/// Smoothing fragment input
struct SmoothingFragmentInput
{
    float4 position     [[position]];
    float2 texcoord;
    float2 blurcoord1;
    float2 blurcoord2;
    float2 blurcoord3;
};

/// Smoothing vertex shader
vertex SmoothingFragmentInput vertex_smoothing(SmoothingVertexInput input [[stage_in]])
{
    SmoothingFragmentInput output;
    output.position = input.position;
    output.texcoord = input.texcoord;
    
    output.blurcoord1 = input.texcoord.xy - 2 * input.size * 1.44;
    output.blurcoord2 = input.texcoord.xy;
    output.blurcoord3 = input.texcoord.xy + 2 * input.size * 1.44;
    return output;
}

/// Smoothing fragment shader
fragment half4 fragment_smoothing(SmoothingFragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]])
{
    half4 sum = half4(0, 0, 0, 1);
    float distanceNormalizationFactor = 7.0;
    float distanceFromCentralColor;
    
    constexpr sampler defaultSampler;
    float gaussianWeight = 0.0;
    float gaussianWeightTotal = 0.0;
    half4 sampleColor;
    
    half4 centralColor = texture.sample(defaultSampler, input.blurcoord2);
    gaussianWeightTotal = 0.18;
    sum = centralColor * 0.18;
    
    sampleColor = texture.sample(defaultSampler, input.blurcoord1);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.27 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = texture.sample(defaultSampler, input.blurcoord3);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.27 * (1.0 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    // gaussianWeightTotal < 0.4 --> centralColor
    // 0.4 <= guassianWeightTotal < 0.5 --> mix(sum / gaussianWeightTotal, centralColor, (gaussianWeightTotal - 0.4) / 0.1)
    // 0.5 <= guassianWeightTotal --> sum / gaussianWeightTotal
    
    half4 temp = mix(centralColor, mix(sum / gaussianWeightTotal, centralColor, (gaussianWeightTotal - 0.4) / 0.1), step(0.4, gaussianWeightTotal));
    return mix(temp, sum / gaussianWeightTotal, step(0.5, gaussianWeightTotal));
}


