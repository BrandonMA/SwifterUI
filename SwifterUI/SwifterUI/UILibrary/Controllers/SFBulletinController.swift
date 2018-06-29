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
}

extension SFBulletinControllerDelegate {
    
    // MARK: - Instance Methods
    
    public func bulletinController(_ bulletinController: SFBulletinController, retreivedValue: String?, index: Int?) {
        
    }
}

open class SFBulletinController: SFViewController, SFInteractionViewController {
    
    // MARK: - Instance Properties
    
    public final var mainView: UIView { return bulletinView.backgroundView }
    public final lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: view)
    public final var snapping: UISnapBehavior?
    
    public final weak var delegate: SFBulletinControllerDelegate? = nil
    
    public final var pickerValues: [String] = []
    public final var buttons: [SFButton] = []
    
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
    
    public final var bulletinTitle: String = "Titulo" {
        didSet {
            bulletinView.titleLabel.text = bulletinTitle
        }
    }
    
    public final lazy var bulletinView: SFBulletinView = {
        let picker = SFBulletinView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, middleView: useButtons ? nil : useDatePicker ? datePicker : pickerView, buttons: buttons)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // MARK: - Initializers
    
    public override init(automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
    }
    
    public convenience init(with values: [String], automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        pickerValues = values
        useDatePicker = false
        useButtons = false
    }
    
    public convenience init(date: Date = Date(), minDate: Date? = nil, maxDate: Date? = nil, automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        useDatePicker = true
        useButtons = false
        datePicker.date = date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    public convenience init(buttons: [SFButton], automaticallyAdjustsColorStyle: Bool = true) {
        self.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        self.buttons = buttons
        useDatePicker = false
        useButtons = true
        buttons.forEach { (button) in
            button.addTarget(self, action: #selector(didTouch(button:)), for: .touchUpInside)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bulletinView)
        bulletinView.closeButton.addTarget(self, action: #selector(closeButtonDidTouch), for: .touchUpInside)
        bulletinView.doneButton.addTarget(self, action: #selector(doneButtonDidTouch), for: .touchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView))
        bulletinView.backgroundView.addGestureRecognizer(panGesture)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bulletinView.clipTop(to: .top, useSafeArea: false)
        bulletinView.clipEdges(exclude: [.top])
        snapping = UISnapBehavior(item: bulletinView.backgroundView, snapTo: bulletinView.backgroundView.center)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let animation = SFScaleAnimation(with: bulletinView.backgroundView, type: .inside)
        animation.duration = 1.0
        animation.damping = 0.7
        animation.velocity = 0.8
        animation.start()
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
    
    @objc private func didTouch(button: SFButton) {
        handleTouch(button: button)
    }
    
    open override func updateColors() {
        super.updateColors()
        DispatchQueue.addAsyncTask(to: .main) {
            self.view.backgroundColor = .clear
            self.pickerView.updateColors()
            self.datePicker.updateColors()
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let snapping = snapping else { return }
        animator.removeBehavior(snapping)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc private func dragView(recognizer: UIPanGestureRecognizer) {
        moveView(recognizer: recognizer)
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












