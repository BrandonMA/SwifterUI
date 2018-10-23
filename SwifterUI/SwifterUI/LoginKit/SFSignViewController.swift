//
//  SFSignViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 22/04/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public enum SFSignState {
    case signIn
    case signUp
}

open class SFSignViewController: SFViewController {
    
    // MARK: - Instance Methods
    
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
        setTargets()
        setColorsForState()
        signView.clipSides()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signView.signInView.alpha = 0.0
        signView.signInView.removeFromSuperview()
    }
    
    private func setTargets() {
        signView.signInButton.addTarget(self, action: #selector(didTouch(button:)), for: .touchUpInside)
        signView.signUpButton.addTarget(self, action: #selector(didTouch(button:)), for: .touchUpInside)
        signView.signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonDidTouch), for: .touchUpInside)
        signView.signInView.signInButton.addTarget(self, action: #selector(signInButtonDidTouch), for: .touchUpInside)
        signView.facebookButton.addTarget(self, action: #selector(facebookButtonDidTouch), for: .touchUpInside)
        signView.signInView.passwordResetButton.addTarget(self, action: #selector(resetPasswordButtonDidTouch), for: .touchUpInside)
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
        
        if signView.signInView.frame.origin.x == 0 {
            signView.signInView.layoutIfNeeded()
            signView.signInView.frame = self.signView.signUpView.frame
            signView.signInView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
        
        signView.signInView.alpha = 0.0
        
        let animator = UIViewPropertyAnimator(damping: 1.0, response: 0.5)
        
        animator.addAnimations {
            self.signView.signUpView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
        
        animator.addCompletion { (_) in
            self.signView.signUpView.removeFromSuperview()
            self.signView.contentStack.insertArrangedSubview(self.signView.signInView, at: 2)
        }
        
        animator.addCompletion { (_) in
            
            let newAnimator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
            
            newAnimator.addAnimations {
                self.signView.signInView.alpha = 1.0
                self.signView.signInView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.signView.layoutIfNeeded()
            }
            
            newAnimator.startAnimation()
        }
        animator.startAnimation()
        
    }
    
    private func showSignUp() {
        
        signView.signUpView.alpha = 0.0
        
        let animator = UIViewPropertyAnimator(damping: 1.0, response: 0.5)
        
        animator.addAnimations {
            self.signView.signInView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
        
        animator.addCompletion { (_) in
            self.signView.signInView.removeFromSuperview()
            self.signView.contentStack.insertArrangedSubview(self.signView.signUpView, at: 2)
        }
        
        animator.addCompletion { (_) in
            
            let newAnimator = UIViewPropertyAnimator(damping: 0.7, response: 0.6)
            
            newAnimator.addAnimations {
                self.signView.signUpView.alpha = 1.0
                self.signView.signUpView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.signView.layoutIfNeeded()
            }
            
            newAnimator.startAnimation()
        }
        
        animator.startAnimation()
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
        guard let name = signView.signUpView.nameTextField.text else { return }
        guard let lastName = signView.signUpView.lastNameTextField.text else { return }
        guard let email = signView.signUpView.mailTextField.text else { return }
        guard let password = signView.signUpView.passwordTextField.text else { return }
        signup(with: name, lastname: lastName, email: email, password: password)
    }
    
    open func signup(with name: String, lastname: String, email: String, password: String) {}
    
    @objc private func signInButtonDidTouch() {
        guard let email = signView.signInView.mailTextField.text else { return }
        guard let password = signView.signInView.passwordTextField.text else { return }
        signin(with: email, password: password)
    }
    
    open func signin(with email: String, password: String) {}
    
    @objc open func facebookButtonDidTouch() {}
    
    @objc open func resetPasswordButtonDidTouch() {
        guard let email = signView.signInView.mailTextField.text else { return }
        resetPassword(with: email)
    }
    
    open func resetPassword(with email: String) {}
    
    open override func updateColors() {
        super.updateColors()
        setColorsForState()
    }
    
}
















