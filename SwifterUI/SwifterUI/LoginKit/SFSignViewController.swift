//
//  SFSignViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 22/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PromiseKit

public enum SFSignState {
    case signIn
    case signUp
}

open class SFSignViewController: SFViewController {
    
    var state: SFSignState = .signUp
    
    public lazy var signView: SFSignView = {
        let view = SFSignView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signView)
        signView.signInButton.addTarget(self, action: #selector(didTouch(button:)), for: .touchUpInside)
        signView.signUpButton.addTarget(self, action: #selector(didTouch(button:)), for: .touchUpInside)
        signView.signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTouch), for: .touchUpInside)
        signView.signInView.signInButton.addTarget(self, action: #selector(signInButtonDidTouch), for: .touchUpInside)
        signView.facebookButton.addTarget(self, action: #selector(facebookButtonDidTouch), for: .touchUpInside)
        signView.signInView.passwordResetButton.addTarget(self, action: #selector(resetPasswordButtonDidTouch), for: .touchUpInside)
        setColorsForState()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        signView.clipEdges()
    }
    
    @objc private func didTouch(button: UIButton) {
        state = button == signView.signInButton ? .signIn : .signUp
        setColorsForState()
        if state == .signIn {
            showSignIn()
        } else if state == .signUp {
            showSignUp()
        }
    }
    
    private func showSignIn() {
        let outAnimation = SFScaleAnimation(with: signView.signUpView, type: .outside)
        outAnimation.duration = 0.6
        outAnimation.start().then { _ -> Promise<Void> in
            self.signView.signUpView.isHidden = true
            self.signView.signInView.isHidden = false
            UIView.animate(withDuration: 0.6, animations: {
                self.signView.layoutIfNeeded()
            })
            let inAnimation = SFScaleAnimation(with: self.signView.signInView, type: .inside)
            inAnimation.duration = 0.6
            return inAnimation.start()
            }.done({
            }).catch({ error in
                self.showError()
            })
    }
    
    private func showSignUp() {
        let outAnimation = SFScaleAnimation(with: signView.signInView, type: .outside)
        outAnimation.duration = 0.6
        outAnimation.start().then { _ -> Promise<Void> in
            self.signView.signUpView.isHidden = false
            self.signView.signInView.isHidden = true
            UIView.animate(withDuration: 0.6, animations: {
                self.signView.layoutIfNeeded()
            })
            let inAnimation = SFScaleAnimation(with: self.signView.signUpView, type: .inside)
            inAnimation.duration = 0.6
            return inAnimation.start()
            }.done({
            }).catch({ error in
                self.showError()
            })
    }
    
    private func setColorsForState() {
        UIView.animate(withDuration: 0.6, animations: {
            if self.state == .signIn {
                self.signView.signUpButton.alpha = 0.5
            } else if self.state == .signUp {
                self.signView.signInButton.alpha = 0.5
            }
        })
    }
    
    @objc private func signUpButtonDidTouch() {
        guard let name = signView.signUpView.nameSection.text else { return }
        guard let lastName = signView.signUpView.lastNameSection.text else { return }
        guard let email = signView.signUpView.mailSection.text else { return }
        guard let password = signView.signUpView.passwordSection.text else { return }
        signup(with: name, lastname: lastName, email: email, password: password)
    }
    
    open func signup(with name: String, lastname: String, email: String, password: String) {
    }
    
    @objc private func signInButtonDidTouch() {
        guard let email = signView.signInView.mailSection.text else { return }
        guard let password = signView.signInView.passwordSection.text else { return }
        signin(with: email, password: password)
    }
    
    open func signin(with email: String, password: String) {
    }
    
    @objc open func facebookButtonDidTouch() {
    }
    
    @objc open func resetPasswordButtonDidTouch() {
        guard let email = signView.signInView.mailSection.text else { return }
        resetPassword(with: email)
    }
    
    open func resetPassword(with email: String) {
        
    }
    
    open override func updateColors() {
        super.updateColors()
        setColorsForState()
    }
    
}
















