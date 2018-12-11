//
//  Shader.metal
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 texture [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 texture;
};

vertex VertexOut vertex_texture(const VertexIn vertexIn [[ stage_in ]]) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.texture = vertexIn.texture;
    return vertexOut;
};

fragment half4 fragment_texture(VertexOut vertexIn [[ stage_in ]], texture2d<float> texture [[ texture(0) ]] ) {
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, vertexIn.texture);
    return half4(color);
}

