//
//  Shader.metal
//  MetalTest
//
//  Created by s.kananat on 2018/12/04.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Constants {
    float moveBy;
};

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

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    float4 color = vertexIn.color;
    // color.rgba = float4((color.r + color.g + color.b) / 3);
    vertexOut.color = color;
    vertexOut.texture = vertexIn.texture;
    return vertexOut;
};

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
};

fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]], texture2d<float> texture [[ texture(0) ]] ) {
    constexpr sampler defaultSampler;
    float4 color = texture.sample(defaultSampler, vertexIn.texture);
    return half4(color);
}

