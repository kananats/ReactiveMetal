//
//  Grayscale.metal
//  MetalTest
//
//  Created by s.kananat on 2018/12/10.
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

vertex VertexOut vertex_grayscale(const VertexIn vertexIn [[ stage_in ]]) {
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.texture = vertexIn.texture;
    return vertexOut;
};

fragment half4 fragment_grayscale(VertexOut vertexIn [[ stage_in ]]) {
    float4 color = vertexIn.color;
    float gray = (color.r + color.g + color.b) / 3;
    return half4(color);
}


