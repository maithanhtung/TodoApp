//
//  CCCellView.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import UIKit

class CCCellView: UIView {
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
    
    var subTitle: String? {
        didSet {
            subTitleLabel.text = subTitle
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = CCFont.titleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = CCFont.subTitleFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.tintColor = .black
        imageView.image = UIImage(named: "chevron")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private func setupView() {
        layer.cornerRadius = 10
        backgroundColor = .systemBlue

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: availableGuide.leadingAnchor, constant: CCMargin.large),
            titleLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: availableGuide.topAnchor, constant: CCMargin.large),

            subTitleLabel.leadingAnchor.constraint(equalTo: availableGuide.leadingAnchor, constant: CCMargin.large),
            subTitleLabel.bottomAnchor.constraint(equalTo: availableGuide.bottomAnchor, constant: -CCMargin.small),
            
            iconImageView.trailingAnchor.constraint(equalTo: availableGuide.trailingAnchor, constant: -CCMargin.large),
            iconImageView.leadingAnchor.constraint(greaterThanOrEqualTo: subTitleLabel.trailingAnchor, constant: CCMargin.large),
            iconImageView.centerYAnchor.constraint(equalTo: availableGuide.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        let titleLabelBottomAnchor: NSLayoutConstraint = titleLabel.bottomAnchor.constraint(equalTo: availableGuide.centerYAnchor, constant: -CCMargin.small)
        titleLabelBottomAnchor.priority = .defaultHigh
        titleLabelBottomAnchor.isActive = true
        
        let subTitleLabelBottomAnchor: NSLayoutConstraint =             subTitleLabel.topAnchor.constraint(equalTo: availableGuide.centerYAnchor)
        subTitleLabelBottomAnchor.priority = .defaultHigh
        subTitleLabelBottomAnchor.isActive = true
    }
    
}


