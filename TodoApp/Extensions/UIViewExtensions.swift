//
//  UIViewExtensions.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 10.7.2021.
//

import UIKit

public extension UIView {
    var availableGuide: UILayoutGuide {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return readableContentGuide
        } else {
            return safeAreaLayoutGuide
        }
    }
}
