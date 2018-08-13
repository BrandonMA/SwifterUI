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
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.signView.signInView.removeFromSuperview()
    }
    
    @objc private func didTouch(button: UIControl) {
        state = button == signView.signInButton ? .signIn : .signUp
        setColorsForState()
        if state == .signIn {
            showSignIn()
        } else if state == .signUp {
            showSignUp()
        }
    }
    
    private func showSignIn() {
        let animation = SFPopAnimation(with: signView.signUpView, type: .outside, damping: 0.8, response: 0.7)
        animation.start().then { _ -> Guarantee<Void> in
            self.signView.signUpView.removeFromSuperview()
            self.signView.contentStack.insertArrangedSubview(self.signView.signInView, at: 2)
            let inAnimation = SFPopAnimation(with: self.signView.signInView, type: .inside, damping: 0.8, response: 0.7)
            UIView.animate(withDuration: 0.4, animations: {
                self.signView.layoutIfNeeded()
            })
            return inAnimation.start()
        }
    }
    
    private func showSignUp() {
        let animation = SFPopAnimation(with: signView.signInView, type: .outside, damping: 0.8, response: 0.7)
        animation.start().then { _ -> Guarantee<Void> in
            self.signView.signInView.removeFromSuperview()
            self.signView.contentStack.insertArrangedSubview(self.signView.signUpView, at: 2)
            let inAnimation = SFPopAnimation(with: self.signView.signUpView, type: .inside, damping: 0.8, response: 0.7)
            UIView.animate(withDuration: 0.4, animations: {
                self.signView.layoutIfNeeded()
            })
            return inAnimation.start()
        }
    }
    
    private func setColorsForState() {
        UIView.animate(withDuration: 0.4, animations: {
            if self.state == .signIn {
                self.signView.signUpButton.alpha = 0.5
                self.signView.signInButton.alpha = 1.0
            } else if self.state == .signUp {
                self.signView.signInButton.alpha = 0.5
                self.signView.signUpButton.alpha = 1.0
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
















