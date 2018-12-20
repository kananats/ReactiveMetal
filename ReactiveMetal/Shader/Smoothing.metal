//
//  Smoothing.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/20.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

struct SmoothingVertexInput
{
    float4 position     [[attribute(0)]];
    float2 texcoord     [[attribute(1)]];
    float2 size         [[attribute(2)]];
};

struct SmoothingFragmentInput
{
    float4 position     [[position]];
    float2 texcoord;
    float2 blurcoord1;
    float2 blurcoord2;
    float2 blurcoord3;
};

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

fragment half4 fragment_smoothing(SmoothingFragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]])
{
    half4 sum = half4(0, 0, 0, 1);
    float distanceNormalizationFactor = 7;
    float distanceFromCentralColor;
    constexpr sampler colorSampler;
    float gaussianWeight = 0;
    float gaussianWeightTotal = 0;
    half4 sampleColor;
    
    half4 centralColor = texture.sample(colorSampler, input.blurcoord2);
    gaussianWeightTotal = 0.18;
    sum = centralColor * 0.18;
    
    sampleColor = texture.sample(colorSampler, input.blurcoord1);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.27 * (1 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    sampleColor = texture.sample(colorSampler, input.blurcoord3);
    distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
    gaussianWeight = 0.27 * (1 - distanceFromCentralColor);
    gaussianWeightTotal += gaussianWeight;
    sum += sampleColor * gaussianWeight;
    
    // TODO: Low performance
    if (gaussianWeightTotal < 0.5) {
        if (gaussianWeightTotal < 0.4) {
            return centralColor;
        } else {
            return mix(sum / gaussianWeightTotal, centralColor, (gaussianWeightTotal - 0.4) / 0.1);
        }
    } else {
        return sum / gaussianWeightTotal;
    }
}


