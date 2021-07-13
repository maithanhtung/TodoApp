//
//  LoginViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 10.7.2021.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    private lazy var welcomeLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Todo App"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = UIFont.welcomeTextFont
        
        return label
    }()
    
    private lazy var loginButton: CCButton = {
        let button: CCButton = CCButton()
        
        button.setTitle("Login", for: UIControl.State.normal)
        button.actionHandler = { _ in
            self.loginButtonPressed()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(welcomeLabel)
        view.addSubview(loginButton)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.availableGuide.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.availableGuide.topAnchor, constant: CCMargin.xx_large*6),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor, constant: CCMargin.large),
            loginButton.topAnchor.constraint(equalTo: view.availableGuide.centerYAnchor, constant: CCMargin.xx_large*3),
            loginButton.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor, constant: CCMargin.xx_large),
            loginButton.trailingAnchor.constraint(equalTo: view.availableGuide.trailingAnchor, constant: -CCMargin.xx_large)
        ])
    }
    
    private func loginButtonPressed() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please enable Face ID/ Touch ID from device settings."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.authenticationSuccessfully()
                    } else {
                        self?.authenticationError(with: "Unable to login", message: "Is this you? Please try again")
                    }
                }
            }
        } else {
            authenticationError(with: "Unable to login", message: "Your device unable to use biometric authentication")
        }
    }
    
    private func authenticationError(with title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    private func authenticationSuccessfully() {
        print("success")
    }
}

