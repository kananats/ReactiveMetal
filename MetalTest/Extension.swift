//
//  Extension.swift
//  MetalTest
//
//  Created by s.kananat on 2018/12/07.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

public extension Reactive where Base: UIDevice {
    
    /// Returns the physical orientation of the device (observable)
    var orientation: Signal<UIDeviceOrientation, NoError> {
        return NotificationCenter.default.reactive.notifications(forName: UIDevice.orientationDidChangeNotification).map { ($0.object as? UIDevice)!.orientation }
    }
}
