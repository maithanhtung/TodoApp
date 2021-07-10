//
//  UIFontExtensions.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 10.7.2021.
//

import UIKit

public extension UIFont {

    private static let welcomeTextSize: CGFloat = 50
    private static let buttonTextSize: CGFloat = 18
    
    static let welcomeTextFont: UIFont = UIFont(name: "ArialRoundedMTBold", size: welcomeTextSize)!
    static let buttonTextFont: UIFont = UIFont.systemFont(ofSize: buttonTextSize)
}
