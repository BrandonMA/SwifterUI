//
//  SFModalController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFBulletinControllerDelegate: class {
    
    // MARK: - Instance Methods
    
    func bulletinController(_ bulletinController: SFBulletinController, retreivedValue: String?, index: Int?)
    func bulletinController(_ bulletinController: SFBulletinController, didTouch button: UIButton)
    
}

extension SFBulletinControllerDelegate {
    
    // MARK: - Instance Methods
    
    public func bulletinController(_ bulletinController: SFBulletinController, retreivedValue: String?, index: Int?) {
        
    }
    public func bulletinController(_ bulletinController: SFBulletinController, didTouch button: UIButton) {
    }
    
}

open class SFBulletinController: SFViewController {
    
    // MARK: - Instance Properties
    
    open weak var delegate: SFBulletinControllerDelegate? = nil
    
    open var pickerValues: [String] = []
    open var buttons: [UIButton] = []
    
    open var backgroundView: SFBulletinView {
        return self.view as! SFBulletinView
    }
    
    open var useDatePicker: Bool = false
    open var useButtons: Bool = false
    
    open lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    open lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    open var bulletinTitle: String = "Titulo" {
        didSet {
            backgroundView.titleLabel.text = bulletinTitle
        }
    }
    
    private lazy var slideAnimation: SFSlideAnimation = {
        let slideAnimation = SFSlideAnimation(with: backgroundView.backgroundView, direction: .bottom, type: .inside)
        slideAnimation.duration = 0.6
        slideAnimation.animationCurve = .easeOut
        return slideAnimation
    }()
    
    // MARK: - Initializers
    
    public required init(automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
    }
    
    public convenience init(with values: [String], automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        pickerValues = values
        useDatePicker = false
        useButtons = false
    }
    
    public convenience init(date: Date, minDate: Date? = nil, maxDate: Date? = nil, automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        useDatePicker = true
        useButtons = false
        datePicker.date = date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    public convenience init(buttons: [UIButton], automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        useDatePicker = false
        useButtons = true
        buttons.forEach { (button) in
            button.addTarget(self, action: #selector(handleTouch(button:)), for: .touchUpInside)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func loadView() {
        let picker = SFBulletinView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, middleView: useButtons ? nil : useDatePicker ? datePicker : pickerView, buttons: buttons)
        self.view = picker
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.closeButton.addTarget(self, action: #selector(closeButtonDidTouch), for: .touchUpInside)
        backgroundView.doneButton.addTarget(self, action: #selector(doneButtonDidTouch), for: .touchUpInside)
        slideAnimation.start()
        updateColors()
    }
    
    @objc private func closeButtonDidTouch() {
        returnToMainViewController()
        delegate?.bulletinController(self, retreivedValue: nil, index: nil)
    }
    
    @objc private func doneButtonDidTouch() {
        returnToMainViewController()
        if buttons.count == 0 {
            if useDatePicker {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                formatter.timeZone = TimeZone.current
                delegate?.bulletinController(self, retreivedValue: formatter.string(from: datePicker.date), index: nil)
            } else {
                delegate?.bulletinController(self, retreivedValue: pickerValues[pickerView.selectedRow(inComponent: 0)], index: pickerView.selectedRow(inComponent: 0))
            }
        }
    }
    
    @objc private func handleTouch(button: UIButton) {
        returnToMainViewController {
            self.delegate?.bulletinController(self, didTouch: button)
        }
    }
    
    @objc private func returnToMainViewController(completion: (() -> Void)? = nil) {
        slideAnimation.type = .outside
        slideAnimation.start()
        DispatchQueue.delay(by: 0.3, dispatchLevel: .main) {
            self.dismiss(animated: true, completion: completion)
        }
    }
    
    open override func updateColors() {
        super.updateColors()
        if useDatePicker {
            datePicker.setValue(colorStyle.getTextColor(), forKeyPath: "textColor")
            datePicker.setValue(false, forKeyPath: "highlightsToday")
        } else {
            pickerView.reloadAllComponents()
        }
    }
    
}

extension SFBulletinController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = NSAttributedString(string: pickerValues[row], attributes: [.foregroundColor : colorStyle.getTextColor()])
        return string
    }
    
}












