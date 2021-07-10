//
//  CCButton.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 11.7.2021.
//

import UIKit

class CCButton: UIButton {
    private let kButtonPaddingTopBottom: CGFloat = 12
    private let kButtonPaddingLeftRight: CGFloat = 32
    private let kButtonMinimumWidth: CGFloat = 180

    
    public typealias TouchUpInsideHandler = (CCButton) -> Void
    public var actionHandler: TouchUpInsideHandler?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.buttonTextFont
        contentEdgeInsets = UIEdgeInsets(top: kButtonPaddingTopBottom, left: kButtonPaddingLeftRight,
                                         bottom: kButtonPaddingTopBottom, right: kButtonPaddingLeftRight)
        let minimumWidthConstraint: NSLayoutConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: kButtonMinimumWidth)
        minimumWidthConstraint.priority = .defaultHigh
        minimumWidthConstraint.isActive = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        basicInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicInit()
    }

    private func basicInit() {
        setBackgroundColor(.systemBlue, for: .normal)
        addTarget(self, action: #selector(touchUpSelector(_:)), for: .touchUpInside)
    }
    
    @objc private func touchUpSelector(_ sender: CCButton) {
        actionHandler?(sender)
    }
    
    private func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))

        if let graphicsContext = UIGraphicsGetCurrentContext() {
            graphicsContext.setFillColor(color.cgColor)
            graphicsContext.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            setBackgroundImage(colorImage, for: state)

            clipsToBounds = true
        }
    }
    
}
