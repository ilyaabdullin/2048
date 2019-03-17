//
//  Board2048View.swift
//  2048
//
//  Created by Ilya Abdullin on 17/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

@IBDesignable class Board2048View: UIView {
    
    @IBInspectable var size: Int = 4
    
    var tilePlaces = [UIView]()
    var tiles = [Tile2048View]()

    override func draw(_ rect: CGRect) {
        layer.backgroundColor = Board2048View.bgBoardColor.cgColor
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layer.cornerRadius = cornerRadius
        bounds.size.height = bounds.size.width
        
        //draw empty tiles
        for row in 0..<size {
            for column in 0..<size {
                let tilePlace = UIView(frame: CGRect(origin: getTileMinXMinYPoint(row: row, column: column), size: tileSize))
                tilePlace.layer.backgroundColor = Board2048View.bgEmptyTileColor.cgColor
                tilePlace.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                tilePlace.layer.cornerRadius = cornerRadius

                tilePlaces.append(tilePlace)
                self.addSubview(tilePlace)
            }
        }
    }
}

extension Board2048View {
    static var bgBoardColor = #colorLiteral(red: 0.7352144122, green: 0.6780939698, blue: 0.6294513941, alpha: 1)
    static var bgEmptyTileColor = #colorLiteral(red: 0.8055974841, green: 0.7564521432, blue: 0.7078657746, alpha: 1)
    
    private var padding: CGFloat {
        return bounds.size.width / CGFloat(11 * size + 1)
    }
    
    private var tileSize: CGSize {
        return CGSize(width: padding * 10, height: padding * 10)
    }
    
    private var cornerRadius: CGFloat {
        return tileSize.height * 0.05
    }
    
    private func getTileMinXMinYPoint(row: Int, column: Int) -> CGPoint {
        let x = padding * CGFloat(row + 1) + tileSize.width * CGFloat(row)
        let y = padding * CGFloat(column + 1) + tileSize.height * CGFloat(column)
        return CGPoint(x: x, y: y)
    }
    
}
