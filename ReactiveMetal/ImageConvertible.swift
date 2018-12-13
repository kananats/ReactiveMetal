//
//  ImageConvertible.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/13.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import MetalKit

// MARK: Main
/// A type that can be converted to image
public protocol ImageConvertible {
    
    /// `CGImage` representation
    var _cgImage: CGImage? { get }
}

// MARK: Internal
internal extension ImageConvertible {
    
    /// `UIImage` representation
    var _uiImage: UIImage? {
        guard let _cgImage = self._cgImage else { return nil }
        return UIImage(cgImage: _cgImage)
    }
    
    /// `CIImage` representation
    var _ciImage: CIImage? {
        guard let _cgImage = self._cgImage else { return nil }
        return CIImage(cgImage: _cgImage)
    }

    /// `MTLTexture` representation
    var _mtlTexture: MTLTexture? {
        guard let _cgImage = self._cgImage else { return nil }
        let loader = MTKTextureLoader(device: MTL.default.device)
        return try? loader.newTexture(cgImage: _cgImage, options: [.SRGB: false])
    }
}

// MARK: Extension
extension UIImage: ImageConvertible {
    public var _cgImage: CGImage? { return self.cgImage }
}

extension CGImage: ImageConvertible {
    public var _cgImage: CGImage? { return self }
}

extension CIImage: ImageConvertible {
    public var _cgImage: CGImage? { return self.cgImage }
}

extension String: ImageConvertible {
    public var _cgImage: CGImage? {
        guard let image = UIImage(named: self) else { return nil }
        return image.cgImage
    }
}
