//
//  CCLabel.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 15.7.2021.
//

import UIKit

class CCLabel: UILabel {

    public init() {
        super.init(frame: .zero)
        basicInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicInit()
    }
    
    func basicInit() {
        textAlignment = .left
        textColor = UIColor(named: "labelColor")
        numberOfLines = 0
    }
}
