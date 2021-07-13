//
//  CCFont.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

class CCFont: UIFont {
    private static let giant: CGFloat = 50
    
    private static let xLarge: CGFloat = 18
    private static let large: CGFloat = 16
    private static let medium: CGFloat = 14
    private static let small: CGFloat = 12
    private static let xSmall: CGFloat = 11
    

    static let welcomeTextFont: UIFont = UIFont(name: "ArialRoundedMTBold", size: giant)!
    static let buttonTextFont: UIFont = UIFont.systemFont(ofSize: xLarge)
    static let titleFont: UIFont = UIFont.systemFont(ofSize: medium)
    static let subTitleFont: UIFont = UIFont.systemFont(ofSize: xLarge)
}


