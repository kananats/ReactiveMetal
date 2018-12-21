//
//  Extension.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/07.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import MetalKit
import Result
import ReactiveSwift
import ReactiveCocoa

public extension Reactive where Base: UIDevice {
    
    /// Returns the physical orientation of the device (observable)
    var orientation: Signal<UIDeviceOrientation, NoError> {
        return NotificationCenter.default.reactive.notifications(forName: UIDevice.orientationDidChangeNotification).map { ($0.object as? UIDevice)!.orientation }
    }
}

public extension UIImage {
    
    /// Initializes and returns an image object with the specified `MTLTexture` object
    convenience init?(mtlTexture: MTLTexture?) {
        guard let mtlTexture = mtlTexture else { return nil }
        
        // Fix mirror
        guard let ciImage = CIImage(mtlTexture: mtlTexture)?.transformed(by: CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: CGFloat(mtlTexture.height))) else { return nil }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        self.init(cgImage: cgImage)
    }
}
