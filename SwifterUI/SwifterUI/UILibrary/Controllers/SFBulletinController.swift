//
//  SFModalController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 16/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFBulletinViewControllerDelegate: class {
    
    // MARK: - Instance Methods
    
    func bulletinController(_ bulletinController: SFBulletinViewController, retreivedValue: String?, index: Int?)
}

extension SFBulletinViewControllerDelegate {
    
    // MARK: - Instance Methods
    
    public func bulletinController(_ bulletinController: SFBulletinViewController, retreivedValue: String?, index: Int?) {
        
    }
}

open class SFBulletinViewController: SFPopViewController {
    
    // MARK: - Instance Properties
    
    public final weak var delegate: SFBulletinViewControllerDelegate?
    
    public final var pickerValues: [String] = []
    public final var buttons: [SFFluidButton] = []
    
    public final var useDatePicker: Bool = false
    public final var useButtons: Bool = false
    
    public final lazy var pickerView: SFPickerView = {
        let pickerView = SFPickerView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    public final lazy var datePicker: SFDatePicker = {
        let datePicker = SFDatePicker(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    public final var bulletinTitle: String {
        get {
            return bulletinView.titleLabel.text ?? ""
        } set {
            DispatchQueue.main.async {
                self.bulletinView.titleLabel.text = newValue
            }
        }
    }
    
    public final var bulletinMessage: String {
        get {
            return bulletinView.messageLabel.text ?? ""
        } set {
            DispatchQueue.main.async {
                self.bulletinView.messageLabel.text = newValue
            }
        }
    }
    
    public final lazy var bulletinView: SFBulletinView! = { return popView as? SFBulletinView }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
    }
    
    public convenience init(title: String = "", with values: [String], automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        pickerValues = values
        bulletinTitle = title
        useDatePicker = false
        useButtons = false
        createBulletinView()
    }
    
    public convenience init(title: String = "",
                            date: Date = Date(),
                            minDate: Date? = nil,
                            maxDate: Date? = nil,
                            automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        useDatePicker = true
        useButtons = false
        bulletinTitle = title
        datePicker.date = date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        createBulletinView()
    }
    
    public convenience init(title: String = "",
                            message: String = "",
                            buttons: [SFFluidButton],
                            automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        bulletinTitle = title
        bulletinMessage = message
        useDatePicker = false
        useButtons = true
        buttons.forEach { (button) in
            let oldActions = button.touchActions
            button.touchActions.removeAll()
            button.insertAction({ [unowned self] in
                self.returnToMainViewController(completion: {
                    oldActions.forEach({ $0() })
                })
            }, at: 0)
        }
        createBulletinView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    internal func createBulletinView() {
        popView = SFBulletinView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle,
                                 middleView: useButtons ? nil : useDatePicker ? datePicker : pickerView,
                                 buttons: buttons)
        popView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bulletinView)
        bulletinView.clipTop(to: .top, useSafeArea: false)
        bulletinView.clipSides(exclude: [.top])
        
        bulletinView.closeButton.addAction { [unowned self] in
            self.closeButtonDidTouch()
        }
        
        bulletinView.doneButton.addAction { [unowned self] in
            self.doneButtonDidTouch()
        }
        
        bulletinView.shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonDidTouch)))
    }
    
    @objc private func closeButtonDidTouch() {
        returnToMainViewController()
        delegate?.bulletinController(self, retreivedValue: nil, index: nil)
    }
    
    private func doneButtonDidTouch() {
        returnToMainViewController()
        if buttons.count == 0 {
            if useDatePicker {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                formatter.timeZone = TimeZone.current
                delegate?.bulletinController(self, retreivedValue: formatter.string(from: datePicker.date), index: nil)
            } else {
                delegate?.bulletinController(self,
                                             retreivedValue: pickerValues[pickerView.selectedRow(inComponent: 0)],
                                             index: pickerView.selectedRow(inComponent: 0))
            }
        }
    }
    
    open override func updateColors() {
        super.updateColors()
        DispatchQueue.main.async {
            self.view.backgroundColor = .clear
            self.pickerView.updateColors()
            self.datePicker.updateColors()
        }
    }
    
}

extension SFBulletinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = NSAttributedString(string: pickerValues[row],
                                        attributes: [.foregroundColor: colorStyle.getTextColor()])
        return string
    }
    
}
