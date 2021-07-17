//
//  CCCellView.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import UIKit

enum CCCellViewStyle: CaseIterable {
    case normalCell,
         selectionCell
}

class CCCellView: UIView {
    public init(style: CCCellViewStyle = .normalCell) {
        super.init(frame: .zero)
        setupView(style: style)
    }

    public required init?(coder aDecoder: NSCoder, style: CCCellViewStyle = .normalCell) {
        super.init(coder: aDecoder)
        setupView(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    var subTitleTextColor: UIColor? = UIColor(named: "labelColor") {
        didSet {
            subTitleLabel.textColor = subTitleTextColor
        }
    }
    
    var taskStatus: TaskStatus? {
        didSet {
            if let taskStatus = taskStatus {
                statusLabel.text = taskStatus.statusString
                statusLabel.textColor = taskStatus.textColor
            }
        }
    }
    
    var style: CCCellViewStyle = .normalCell {
        didSet {
            iconImageView.removeFromSuperview()
            titleLabel.removeFromSuperview()
            subTitleLabel.removeFromSuperview()
            
            setupView(style: style)
        }
    }
    
    private lazy var titleLabel: CCLabel = {
        let label: CCLabel = CCLabel()
        label.font = CCFont.titleFont
        label.textColor = UIColor(named: "titleLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var subTitleLabel: CCLabel = {
        let label: CCLabel = CCLabel()
        label.font = CCFont.subTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var statusLabel: CCLabel = {
        let label: CCLabel = CCLabel()
        label.font = CCFont.subTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.tintColor = UIColor(named: "chevronTintColor")
        imageView.image = UIImage(named: "chevron")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private func setupView(style: CCCellViewStyle) {
        backgroundColor = UIColor(named: "cellBackgroundColor")

        if style == .selectionCell {
            addSubview(iconImageView)
        }
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(statusLabel)
        
        setupConstraints(style: style)
    }
    
    private func setupConstraints(style: CCCellViewStyle) {
        
        switch style {
        case .normalCell:
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: availableGuide.leadingAnchor, constant: CCMargin.large),
                titleLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
                titleLabel.topAnchor.constraint(equalTo: availableGuide.topAnchor, constant: CCMargin.large),

                subTitleLabel.leadingAnchor.constraint(equalTo: availableGuide.leadingAnchor, constant: CCMargin.large),
                subTitleLabel.bottomAnchor.constraint(equalTo: availableGuide.bottomAnchor, constant: -CCMargin.small),
                
                statusLabel.centerYAnchor.constraint(equalTo: availableGuide.centerYAnchor),
                statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: subTitleLabel.trailingAnchor, constant: CCMargin.large*2),
                statusLabel.trailingAnchor.constraint(equalTo: availableGuide.trailingAnchor, constant: -CCMargin.x_large*2)
            ])
        case .selectionCell:
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: availableGuide.leadingAnchor, constant: CCMargin.large),
                titleLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
                titleLabel.topAnchor.constraint(equalTo: availableGuide.topAnchor, constant: CCMargin.large),

                subTitleLabel.leadingAnchor.constraint(equalTo: availableGuide.leadingAnchor, constant: CCMargin.large),
                subTitleLabel.bottomAnchor.constraint(equalTo: availableGuide.bottomAnchor, constant: -CCMargin.small),
                
                iconImageView.trailingAnchor.constraint(equalTo: availableGuide.trailingAnchor, constant: -CCMargin.large),
                iconImageView.centerYAnchor.constraint(equalTo: availableGuide.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 10),
                iconImageView.heightAnchor.constraint(equalToConstant: 10),
                
                statusLabel.centerYAnchor.constraint(equalTo: availableGuide.centerYAnchor),
                statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: subTitleLabel.trailingAnchor, constant: CCMargin.small),
                statusLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -CCMargin.small)
            ])
        }
        
        let titleLabelBottomAnchor: NSLayoutConstraint = titleLabel.bottomAnchor.constraint(equalTo: availableGuide.centerYAnchor, constant: -CCMargin.small)
        titleLabelBottomAnchor.priority = .defaultHigh
        titleLabelBottomAnchor.isActive = true
        
        let subTitleLabelTopAnchor: NSLayoutConstraint = subTitleLabel.topAnchor.constraint(equalTo: availableGuide.centerYAnchor)
        subTitleLabelTopAnchor.priority = .defaultHigh
        subTitleLabelTopAnchor.isActive = true
    }
    
}


