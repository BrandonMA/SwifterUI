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

open class SFBulletinViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    public final var mainView: UIView { return bulletinView.backgroundView }
    
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
            DispatchQueue.addAsyncTask(to: .main) {
                self.bulletinView.titleLabel.text = newValue
            }
        }
    }
    
    public final var bulletinMessage: String {
        get {
            return bulletinView.messageLabel.text ?? ""
        } set {
            DispatchQueue.addAsyncTask(to: .main) {
                self.bulletinView.messageLabel.text = newValue
            }
        }
    }
    
    public final lazy var bulletinView: SFBulletinView = {
        let picker = SFBulletinView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, middleView: useButtons ? nil : useDatePicker ? datePicker : pickerView, buttons: buttons)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var animation = SFPopAnimation(with: mainView, damping: 0.8, response: 0.7)
    
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
    }
    
    public convenience init(title: String = "", date: Date = Date(), minDate: Date? = nil, maxDate: Date? = nil, automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        useDatePicker = true
        useButtons = false
        bulletinTitle = title
        datePicker.date = date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    public convenience init(title: String = "", message: String = "", buttons: [SFFluidButton], automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        bulletinTitle = title
        bulletinMessage = message
        useDatePicker = false
        useButtons = true
        buttons.forEach { (button) in
            button.insertAction({ [unowned self] in
                self.returnToMainViewController(completion: {
                    button.touchActions.forEach({ $0() })
                })
            }, at: 0)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bulletinView)
        
        bulletinView.closeButton.addTouchAction { [unowned self] in
            self.closeButtonDidTouch()
        }
        
        bulletinView.doneButton.addTouchAction { [unowned self] in
            self.doneButtonDidTouch()
        }
        
        bulletinView.shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonDidTouch)))
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bulletinView.clipTop(to: .top, useSafeArea: false)
        bulletinView.clipEdges(exclude: [.top])
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animation.start()
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
                delegate?.bulletinController(self, retreivedValue: pickerValues[pickerView.selectedRow(inComponent: 0)], index: pickerView.selectedRow(inComponent: 0))
            }
        }
    }
    
    open override func updateColors() {
        super.updateColors()
        DispatchQueue.addAsyncTask(to: .main) {
            self.view.backgroundColor = .clear
            self.pickerView.updateColors()
            self.datePicker.updateColors()
        }
    }
    
    public func returnToMainViewController(completion: (() -> Void)? = nil) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.mainView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
        animator.addCompletion { (_) in
            self.dismiss(animated: true, completion: completion)
        }
        animator.startAnimation()
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
        let string = NSAttributedString(string: pickerValues[row], attributes: [.foregroundColor : colorStyle.getTextColor()])
        return string
    }
    
}












