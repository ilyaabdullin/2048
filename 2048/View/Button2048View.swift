//
//  Button2048View.swift
//  2048
//
//  Created by Ilya Abdullin on 22/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

@IBDesignable class Button2048View: UIButton {
    static let bgColor = #colorLiteral(red: 0.5594766736, green: 0.4778994918, blue: 0.4007522464, alpha: 1)
    static let textColor = #colorLiteral(red: 0.9768713117, green: 0.9645584226, blue: 0.9483012557, alpha: 1)
    
    var cornerRadius: CGFloat {
        return bounds.height * 0.05
    }
    
    override func draw(_ rect: CGRect) {
        layer.backgroundColor = Button2048View.bgColor.cgColor
        layer.cornerRadius = cornerRadius
        titleLabel?.textColor = Button2048View.textColor
    }
}
