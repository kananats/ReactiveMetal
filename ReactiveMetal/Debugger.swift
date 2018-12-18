/*
//
//  Debugger.swift
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/13.
//  Copyright © 2018 s.kananat. All rights reserved.
//

import UIKit
import ReactiveSwift
import SnapKit

// MARK: Main
/// Debugger
public final class Debugger: UIView {
    
    /// Initializes
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
    
    /// Shared debugger
    public static let `default` = Debugger()
    
    /// Creates a slider with specified range to control property
    @discardableResult
    func makeSilder<Value: DoubleConvertible, Property: MutablePropertyProtocol>(for property: Property, range: ClosedRange<Value>, label text: String? = nil) -> Disposable? where Property.Value == Value {
        
        let view = UIView()
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        
        let slider = UISlider()
        
        slider.minimumValue = Float(range.lowerBound.double)
        slider.maximumValue = Float(range.upperBound.double)
        
        let disposable = CompositeDisposable()
        
        disposable += slider.reactive.value <~ property.map { Float($0.double) }
        disposable += property <~ slider.reactive.controlEvents(.valueChanged).map { $0.value as! Value }
        
        view.addSubview(label)
        label.snp.remakeConstraints { make in
            make.left.equalTo(view.snp.left).offset(12)
            make.right.equalTo(view.snp.right).multipliedBy(0.25).offset(-8)
            make.top.bottom.equalToSuperview()
        }
        
        view.addSubview(slider)
        slider.snp.remakeConstraints { make in
            make.left.equalTo(view.snp.right).multipliedBy(0.25).offset(8)
            make.right.equalTo(view.snp.right).offset(-12)
            make.top.bottom.equalToSuperview()
        }
        
        self.add(view)
        
        disposable += { [weak self] in self?.remove(slider) }
        
        return disposable
    }
}

// MARK: Private
private extension Debugger {

    func add(_ view: UIView) {
        DispatchQueue.main.async {
            self.addSubview(view)

            self.remakeConstraints()
        }
    }
    
    func remove(_ view: UIView) {
        DispatchQueue.main.async {
            view.removeFromSuperview()
            
            self.remakeConstraints()
        }
    }
    
    private func remakeConstraints() {
        for index in 0 ..< self.subviews.count {
            self.subviews[index].snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.top.equalToSuperview().offset(index * 50 + 20)
                make.height.equalTo(50)
            }
        }
    }
}
*/
