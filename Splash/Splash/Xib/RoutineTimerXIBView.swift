//
//  RoutineTimerXIBView.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 8/6/22.
//

import UIKit
import CircularSlider

class RoutineTimerXIBView: UIView, CircularSliderDelegate {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var circularSlider: CircularSlider!
    var maxValue = Float()
    var value = Float()
    var timer = Timer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    // MARK: - Methods to set up view and circular slider
    private func customInit () {
        Bundle.main.loadNibNamed("RoutineTimerXIB", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupCircularSlider()
        value = 0.0
        circularSlider.title = Helper.formatTimeString(0)
        circularSlider.layer.cornerRadius = 16
    }
    
    fileprivate func setupCircularSlider() {
        circularSlider.delegate = self
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = maxValue
    }
    
    // MARK: - Methods to change value of circular timer
    func incrementValue() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeValue), userInfo: nil, repeats: true)
    }
    
    @objc func changeValue() {
        circularSlider.setValue(circularSlider.value + 1, animated: true)
        value = circularSlider.value
        circularSlider.maximumValue = maxValue
        circularSlider.title = Helper.formatTimeString(Int32(circularSlider.value))
        if (circularSlider.value == circularSlider.maximumValue) {
            self.timer.invalidate()
        }
    }
    
    // MARK: - CircularSliderDelegate
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {
        return floorf(value)
    }
       
       
}
