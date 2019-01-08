//
//  HSV.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#import "MTLHeader.h"

/// HSV fragment shader
fragment half4 fragment_hsv(FragmentInput input [[stage_in]], texture2d<half> texture [[texture(0)]], device const float &hue [[buffer(0)]], device const float &saturation [[buffer(1)]], device const float &value [[buffer(2)]]) {
    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);
    
    half3 hsv = rgb_to_hsv(color.rgb);
    hsv.x += hue;
    hsv.yz *= half2(saturation, value);
    half3 rgb = hsv_to_rgb(hsv);
    
    return half4(rgb, color.a);
}

