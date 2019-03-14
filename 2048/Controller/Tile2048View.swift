//
//  Tile2048View.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

@IBDesignable class Tile2048View: UIView {

    var value: Int? = 1024 {
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
        case 2:             return UIColor(rgb: 0xeee4da)
        case 4:             return UIColor(rgb: 0xede0c8)
        case 8:             return UIColor(rgb: 0xf2b179)
        case 16:            return UIColor(rgb: 0xf59563)
        case 32:            return UIColor(rgb: 0xf67c5f)
        case 64:            return UIColor(rgb: 0xf65e3b)
        case 128:           return UIColor(rgb: 0xedcf72)
        case 256:           return UIColor(rgb: 0xedcc61)
        case 512:           return UIColor(rgb: 0xedc850)
        case 1024:          return UIColor(rgb: 0xedc53f)
        case 2048:          return UIColor(rgb: 0xedc22e)
        case 4096:          return UIColor(rgb: 0xFFBFBF)
        case 8192:          return UIColor(rgb: 0xFFBFEF)
        case 16384:         return UIColor(rgb: 0xEABFFF)
        case 32768:         return UIColor(rgb: 0xFF80DF)
        case 65536:         return UIColor(rgb: 0xD580FF)
        case 131072:        return UIColor(rgb: 0xFF8080)
        case 262144:        return UIColor(rgb: 0xFF0000)
        case 524288:        return UIColor(rgb: 0xCC0099)
        case 1048576:       return UIColor(rgb: 0x8F006B)
        case 2097152:       return UIColor(rgb: 0x660099)
        case 4194304:       return UIColor(rgb: 0x47006B)
        case 8388608:       return UIColor(rgb: 0xBFCFFF)
        case 16777216:      return UIColor(rgb: 0x809FFF)
        case 33554432:      return UIColor(rgb: 0x0033CC)
        case 134217728:     return UIColor(rgb: 0x00248F)
        case 268435456:     return UIColor(rgb: 0xBFFFFF)
        case 536870912:     return UIColor(rgb: 0x80FFFF)
        case 1073741824:    return UIColor(rgb: 0x009999)
        case 2147483648:    return UIColor(rgb: 0x232323)
            
        default:
            return UIColor(rgb: 0xFFFFFF)
        }
    }
    
    private var tileTextColor: UIColor {
        switch value {
        case 2, 4: return UIColor(rgb: 0x776e65)
        default:
            return UIColor(rgb: 0xf9f6f2)
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

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
