//
//  CCCell.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import UIKit

class CCCell: UICollectionViewCell {
    
    private let innerView: CCCellView = CCCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(with: innerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(with: innerView)
    }
    
    public init() {
        super.init(frame: .zero)
        setup(with: innerView)
    }
    
    var cellStyle: CCCellViewStyle = .normalCell {
        didSet {
            innerView.style = cellStyle
        }
    }
    
    var title: String? {
        didSet {
            innerView.title = title
        }
    }
    
    var subTitle: String? {
        didSet {
            innerView.subTitle = subTitle
        }
    }
    
    var taskStatus: TaskStatus? {
        didSet {
            if let taskStatus = taskStatus {
                innerView.taskStatus = taskStatus
            }
        }
    }
    
    func setup(with innerView: UIView) {
        contentView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.layer.cornerRadius = 10
        
        let screenRect = UIScreen.main.bounds
        var innerViewWidth: CGFloat
        if UIDevice.current.orientation.isLandscape {
            innerViewWidth = screenRect.size.height - CCMargin.large*2
        } else {
            innerViewWidth = screenRect.size.width - CCMargin.large*2
        }
        let innerViewHeight = innerViewWidth/3


        // Setup constraints for the view to content view
        NSLayoutConstraint.activate([
            innerView.leadingAnchor.constraint(equalTo: contentView.availableGuide.leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: contentView.availableGuide.trailingAnchor),
            innerView.topAnchor.constraint(equalTo: contentView.availableGuide.topAnchor),
            innerView.bottomAnchor.constraint(equalTo: contentView.availableGuide.bottomAnchor),
            innerView.widthAnchor.constraint(equalToConstant: innerViewWidth),
            innerView.heightAnchor.constraint(equalToConstant: innerViewHeight)
        ])
    }
    
}
