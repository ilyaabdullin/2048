//
//  Tile2048View.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

@IBDesignable class Tile2048View: UIView {

    var value: Int? = 8192 {
        didSet {
            label.text = String(value!)
            setNeedsDisplay()
        }
    }
    
    var label : UIBorderedLabel!
    
    override func draw(_ rect: CGRect) {
        if !isHidden {
            backgroundColor = .clear
            
            if label == nil { //perform label
                label = UIBorderedLabel(frame: CGRect(origin: CGPoint.zero, size: frame.size))
                label.rightInset = padding
                label.leftInset = padding
                label.textAlignment = .center
                label.numberOfLines = 1
                label.font = UIFont(name: "Helvetica-Bold", size: self.frame.height * 0.67)
                label.minimumScaleFactor = 1 / self.label.font.pointSize
                label.adjustsFontSizeToFitWidth = true
                label.baselineAdjustment = .alignCenters
                label.layer.cornerRadius = cornerRadius
                label.textColor = tileTextColor
            }
            
            if value != nil { //set value tile and bgcolor
                label.layer.backgroundColor = tileBackgroundColor.cgColor
                label.text = String(value!)
            }
            else {
                label.layer.backgroundColor = #colorLiteral(red: 0.8055974841, green: 0.7564521432, blue: 0.7078657746, alpha: 1)
                label.text = ""
            }
            
            if !label.isDescendant(of: self) { //add label if this need
                addSubview(label)
            }
        }
    }

}

//constants and draw func
extension Tile2048View {
    private var cornerRadius: CGFloat {
        return bounds.size.height * 0.1
    }
    
    private var padding: CGFloat {
        return 2.0
    }
    
    private var tileBackgroundColor: UIColor {
        switch value {
        case 2:             return #colorLiteral(red: 0.9333, green: 0.8941, blue: 0.8549, alpha: 1)
        case 4:             return #colorLiteral(red: 0.9294, green: 0.8784, blue: 0.7843, alpha: 1)
        case 8:             return #colorLiteral(red: 0.949, green: 0.6941, blue: 0.4745, alpha: 1)
        case 16:            return #colorLiteral(red: 0.9608, green: 0.5843, blue: 0.3882, alpha: 1)
            
        case 32:            return #colorLiteral(red: 0.9647, green: 0.4863, blue: 0.3725, alpha: 1)
        case 64:            return #colorLiteral(red: 0.9647, green: 0.3686, blue: 0.2314, alpha: 1)
        case 128:           return #colorLiteral(red: 0.9294, green: 0.8118, blue: 0.4471, alpha: 1)
        case 256:           return #colorLiteral(red: 0.9294, green: 0.8, blue: 0.3804, alpha: 1)
            
        case 512:           return #colorLiteral(red: 0.9294, green: 0.7843, blue: 0.3137, alpha: 1)
        case 1024:          return #colorLiteral(red: 0.9294, green: 0.7725, blue: 0.2471, alpha: 1)
        case 2048:          return #colorLiteral(red: 0.9294, green: 0.7608, blue: 0.1804, alpha: 1)
        case 4096:          return #colorLiteral(red: 1, green: 0.749, blue: 0.749, alpha: 1)
            
        case 8192:          return #colorLiteral(red: 1, green: 0.749, blue: 0.9373, alpha: 1)
        case 16384:         return #colorLiteral(red: 0.9176, green: 0.749, blue: 1, alpha: 1)
        case 32768:         return #colorLiteral(red: 1, green: 0.502, blue: 0.8745, alpha: 1)
        case 65536:         return #colorLiteral(red: 0.8353, green: 0.502, blue: 1, alpha: 1)
            
        case 131072:        return #colorLiteral(red: 1, green: 0.502, blue: 0.502, alpha: 1)
        case 262144:        return #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        case 524288:        return #colorLiteral(red: 0.8, green: 0, blue: 0.6, alpha: 1)
        case 1048576:       return #colorLiteral(red: 0.702, green: 0, blue: 0, alpha: 1)
            
        case 2097152:       return #colorLiteral(red: 0.5608, green: 0, blue: 0.4196, alpha: 1)
        case 4194304:       return #colorLiteral(red: 0.4, green: 0, blue: 0.6, alpha: 1)
        case 8388608:       return #colorLiteral(red: 0.2784, green: 0, blue: 0.4196, alpha: 1)
        case 16777216:      return #colorLiteral(red: 0.749, green: 0.8118, blue: 1, alpha: 1)
            
        case 33554432:      return #colorLiteral(red: 0.502, green: 0.6235, blue: 1, alpha: 1)
        case 67108864:      return #colorLiteral(red: 0, green: 0.2, blue: 0.8, alpha: 1)
        case 134217728:     return #colorLiteral(red: 0, green: 0.1412, blue: 0.5608, alpha: 1)
        case 268435456:     return #colorLiteral(red: 0.749, green: 1, blue: 1, alpha: 1)
            
        case 536870912:     return #colorLiteral(red: 0.502, green: 1, blue: 1, alpha: 1)
        case 1073741824:    return #colorLiteral(red: 0, green: 0.6, blue: 0.6, alpha: 1)
        case 2147483648:    return #colorLiteral(red: 0, green: 0.4196, blue: 0.4196, alpha: 1)
        case 4294967296:    return #colorLiteral(red: 0.5843, green: 0.5686, blue: 0.549, alpha: 1)
            
        default:
            return #colorLiteral(red: 0.1373, green: 0.1373, blue: 0.1373, alpha: 1)
        }
    }
    
    private var tileTextColor: UIColor {
        switch value {
        case 2, 4, 268435456, 536870912: return #colorLiteral(red: 0.4667, green: 0.4314, blue: 0.3961, alpha: 1)
        default:
            return #colorLiteral(red: 0.9765, green: 0.9647, blue: 0.949, alpha: 1)
        }
    }
}

//it is for add padding for tile with more than two numbers
class UIBorderedLabel: UILabel {
    
    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 0
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawText(in: rect.inset(by: insets))
    }
}
