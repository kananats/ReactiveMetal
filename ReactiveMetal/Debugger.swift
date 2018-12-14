//
//  Debugger.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/13.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveSwift

// MARK: Main
/// Debugger
public final class Debugger: UIView {
    
    public static let `default` = Debugger()
    
    private init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            self.frame = window.frame
            
            window.addSubview(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Extension
public extension Debugger {
    
    /// Creates a slider with specified range to control property
    @discardableResult
    func makeSilder<Value: DoubleConvertible, Property: MutablePropertyProtocol>(for property: Property, range: ClosedRange<Value>) -> Disposable? where Property.Value == Value {
        let slider = UISlider()
        
        slider.minimumValue = Float(range.lowerBound.double)
        slider.maximumValue = Float(range.upperBound.double)
        
        let disposable = CompositeDisposable()
        
        disposable += slider.reactive.value <~ property.map { Float($0.double) }
        disposable += property <~ slider.reactive.controlEvents(.valueChanged).map { $0.value as! Value }
        
        self.add(slider)
        
        disposable += { [weak self] in self?.remove(slider) }
        
        return disposable
    }
}

// MARK: Private
private extension Debugger {
    
    static var margin: CGFloat = 10
    
    // TODO: use snapkit
    func add(_ view: UIView) {
        DispatchQueue.main.async {
            let frame = CGRect(x: 12, y: Debugger.margin, width: self.bounds.size.width - 24, height: 50)
            view.frame = frame
            
            self.addSubview(view)
            
            Debugger.margin += 50
        }
    }
    
    // TODO: use snapkit
    func remove(_ view: UIView) {
        DispatchQueue.main.async {
            view.removeFromSuperview()
        }
    }
}
