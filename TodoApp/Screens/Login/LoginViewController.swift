//
//  LoginViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 10.7.2021.
//

import UIKit

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
    
    private func loginButtonPressed() {
        
    }
    
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
}

