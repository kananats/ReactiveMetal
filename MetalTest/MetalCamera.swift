//
//  MetalCamera.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/05.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import AVFoundation
import Result
import ReactiveSwift

// MARK: Main
public final class MetalCamera: Camera {
    
    /// Metal supported device
    private let device: MTLDevice
    
    /// Pipe for observing `MTLTexture` output
    private let pipe = Signal<MTLTexture, NoError>.pipe()
    
    init?(device: MTLDevice, position: AVCaptureDevice.Position = .back) {
        self.device = device
        
        super.init(position: position)
    }
}

// MARK: Inheritance
extension MetalCamera {
    
    override public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        super.captureOutput(output, didOutput: sampleBuffer, from: connection)
        
        // Makes `MTLTexture` and forward to pipe
        guard let texture = MetalHelper.makeTexture(from: sampleBuffer) else { return }
        
        self.pipe.input.send(value: texture)
    }
}

// MARK: Protocol
extension MetalCamera: ImageSource {
    
    typealias Output = MTLTexture
    
    var output: Signal<MTLTexture, NoError> { return self.pipe.output }
}
