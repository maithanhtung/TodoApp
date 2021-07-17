//
//  NotificationBanner.swift
//  TopNotificationRecipe
//
//  Created by Dushyant Bansal on 11/02/18.
//  Copyright © 2018 db42.in. All rights reserved.
//
import UIKit

class NotificationBanner {
    static let labelLeftMarging = CGFloat(16)
    static let labelTopMargin = CGFloat(50)
    static let animateDuration = 0.5
    static let bannerAppearanceDuration: TimeInterval = 2
    
    static func show(_ text: String, backgroundColor: UIColor) {
        
        let superView = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        
        let height = CGFloat(50)
        let width = superView.bounds.size.width
        
        let bannerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        bannerView.layer.opacity = 1
        bannerView.backgroundColor = backgroundColor
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView.addSubview(label)
        superView.addSubview(bannerView)
        
        let labelBottomContstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: bannerView, attribute: .bottom, multiplier: 1, constant: -CCMargin.x_large)
        let labelCenterXConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: bannerView, attribute: .centerX, multiplier: 1, constant: 0)
        let labelWidthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width - labelLeftMarging*2)
        let labelTopConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: bannerView, attribute: .top, multiplier: 1, constant: labelTopMargin)
        
        let bannerWidthConstraint = NSLayoutConstraint(item: bannerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let bannerCenterXConstraint = NSLayoutConstraint(item: bannerView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: 0)
        let bannerTopConstraint = NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0-height)
        
        NSLayoutConstraint.activate([labelBottomContstraint, labelCenterXConstraint, labelWidthConstraint, labelTopConstraint, bannerWidthConstraint, bannerCenterXConstraint, bannerTopConstraint])
        
        UIView.animate(withDuration: animateDuration) {
            bannerTopConstraint.constant = 0
            superView.layoutIfNeeded()
        }
        
        //remove subview after time 2 sec
        UIView.animate(withDuration: animateDuration, delay: bannerAppearanceDuration, options: [], animations: {
            bannerTopConstraint.constant = 0 - bannerView.frame.height
            superView.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                bannerView.removeFromSuperview()
            }
        })
    }
}
