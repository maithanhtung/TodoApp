//
//  CCInputFieldView.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

class CCInputFieldView: UIView {
    public init() {
        super.init(frame: .zero)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var inputTag: Int = 0 {
        didSet {
            inputField.tag = inputTag
        }
    }
    
    var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            inputField.delegate = textFieldDelegate
        }
    }
    
    private lazy var titleLabel: CCLabel = {
        let label: CCLabel = CCLabel()
        label.font = CCFont.subTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var inputField: CCTextField = {
        let inputField: CCTextField = CCTextField()
        inputField.layer.cornerRadius = 10
        inputField.layer.borderWidth = 2.0
        inputField.layer.borderColor = UIColor(named: "textFieldBorderColor")?.cgColor
        inputField.backgroundColor = .white
        inputField.translatesAutoresizingMaskIntoConstraints = false
        
        return inputField
    }()
    
    private func setupView() {
        backgroundColor = UIColor(named: "cellBackgroundColor")

        addSubview(inputField)
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CCMargin.medium),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CCMargin.medium),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: CCMargin.medium),
            titleLabel.bottomAnchor.constraint(equalTo: inputField.topAnchor, constant: -CCMargin.medium),
            
            inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CCMargin.medium),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CCMargin.medium),
            inputField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CCMargin.large),
            inputField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
