//
//  TilePlace2048View.swift
//  2048
//
//  Created by Ilya Abdullin on 19/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

@IBDesignable class TilePlace2048View: UIView {
    
    var tiles = [Tile2048View]()
    
    var sumTiles: Int {
        return tiles.map{$0.value}.reduce(0, +)
    }
}

//drawing
extension TilePlace2048View {
    static let bgTilePlaceColor = #colorLiteral(red: 0.8055974841, green: 0.7564521432, blue: 0.7078657746, alpha: 1)
    
    var cornerRadius: CGFloat {
        return bounds.height * 0.05
    }
    
    override func draw(_ rect: CGRect) {
        bounds.size.height = bounds.size.width
        layer.backgroundColor = TilePlace2048View.bgTilePlaceColor.cgColor
        layer.cornerRadius = cornerRadius
    }
}

//equaling
extension TilePlace2048View {
    func equalTo(tileRight: TilePlace2048View) -> Bool {
        return self.tiles.count == tileRight.tiles.count && self.sumTiles == tileRight.sumTiles
    }
}
