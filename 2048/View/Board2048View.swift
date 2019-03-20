//
//  Board2048View.swift
//  2048
//
//  Created by Ilya Abdullin on 17/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

@IBDesignable class Board2048View: UIView {
    
    @IBInspectable var size: Int = 4 {
        didSet {
            fillTilePlaces()
            setNeedsDisplay(bounds)
        }
    }
    
    var tilePlaces = [TilePlace2048View]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fillTilePlaces()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func fillTilePlaces() {
        tilePlaces.removeAll(keepingCapacity: false)
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        for row in 0..<size {
            for column in 0..<size {
                let tilePlace = TilePlace2048View(frame: CGRect(origin: getTileMinXMinYPoint(row: UInt(row), column: UInt(column)), size: tileSize))
                tilePlaces.append(tilePlace)
            }
        }
    }
    
    //animation duration properties
    var durationOfMovingToOneTileAnimation: TimeInterval = 0.05
    var maxDurationOfMoving: TimeInterval = 0.4
    var showingAndMergingTileDuration: TimeInterval = 0.4 * 5
}

//methods and subscript for getting each tile place and each row and column of tile places
extension Board2048View {
    
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < tilePlaces.count / size && column >= 0 && column < tilePlaces.count / size
    }
    
    subscript(row: Int, column: Int) -> TilePlace2048View {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            
            return tilePlaces[(row * size) + column]
        }
    }
    
    private func getRow(by rowIndex: Int) -> [TilePlace2048View] {
        var tileRow = [TilePlace2048View]()
        
        for columnIndex in 0..<size {
            tileRow.append(self[rowIndex, columnIndex])
        }
        
        return tileRow
    }
    
    private func getColumn(by columnIndex: Int) -> [TilePlace2048View] {
        var tileColumn = [TilePlace2048View]()
        
        for rowIndex in 0..<size {
            tileColumn.append(self[rowIndex, columnIndex])
        }
        
        return tileColumn
    }
    
    func getLine(by lineIndex: Int, to direction: UISwipeGestureRecognizer.Direction) -> [TilePlace2048View] {
        switch direction {
        case .left, .right:
            return getRow(by: lineIndex)
        default:
            return getColumn(by: lineIndex)
        }
    }
    
    func firstIndex(of tilePlace: TilePlace2048View) -> (row: Int, column: Int)? {
        if let lineIndex = tilePlaces.firstIndex(of: tilePlace) {
            let row = lineIndex / size
            let column = lineIndex % size
            
            return (row, column)
        }
        
        return nil
    }
    
    func distance(from: TilePlace2048View, to: TilePlace2048View) -> Int? {
        if let fromIndex = firstIndex(of: from), let toIndex = firstIndex(of: to) {
            return (fromIndex.row - toIndex.row) + (fromIndex.column - toIndex.column)
        }
        
        return nil
    }
}

//methods to adding, moving and merging tiles in tile places
extension Board2048View {
    func add(tile: Tile2048, to tilePlace: TilePlace2048View) {
        let tileView = Tile2048View.init(frame: tilePlace.frame)
        tileView.tile2048 = tile
        
        tilePlace.tiles.append(tileView)
        self.insertSubview(tileView, at: 1000)
        
        tileView.startShowingAnimation(withDuration: showingAndMergingTileDuration, andDelay: min(durationOfMovingToOneTileAnimation * Double(size/2), maxDurationOfMoving / 2))
    }
    
    func moveTileWithMerging(from: TilePlace2048View, to: TilePlace2048View) {
        if from.tiles.count > 0 {
            let tile = from.tiles.remove(at: 0)
            to.tiles.append(tile)
            
            let duration = min(durationOfMovingToOneTileAnimation * Double(abs(distance(from: from, to: to)!)), maxDurationOfMoving)
            
            UIView.animate(withDuration: duration, animations: {
                tile.frame = to.frame
            }) { (finished) in
                if !finished {
                    return
                }
                
                self.mergeTiles(in: to)
            }
        }
    }
    
    func mergeTiles(in tilePlaceWithTileForMerging: TilePlace2048View) {
        if let firstTile = tilePlaceWithTileForMerging.tiles.first {
            for tile in tilePlaceWithTileForMerging.tiles {
                if firstTile !== tile {
                    firstTile.tile2048 = Tile2048(value: firstTile.tile2048.value + tile.tile2048.value)
                    remove(tile: tile, from: tilePlaceWithTileForMerging)
                    
                    firstTile.startMergingAnimation(withDuration: showingAndMergingTileDuration)
                }
            } 
        }
    }
    
    func remove(tile: Tile2048View, from: TilePlace2048View) {
        tile.removeFromSuperview()
        from.tiles.remove(at: from.tiles.firstIndex(of: tile)!)
    }
}

//drawing
extension Board2048View {
    static let bgBoardColor = #colorLiteral(red: 0.7352144122, green: 0.6780939698, blue: 0.6294513941, alpha: 1)
    
    private var padding: CGFloat {
        return bounds.size.width / CGFloat(11 * size + 1)
    }
    
    private var tileSize: CGSize {
        return CGSize(width: padding * 10, height: padding * 10)
    }
    
    private var cornerRadius: CGFloat {
        return tileSize.height * 0.05
    }
    
    private func getTileMinXMinYPoint(row: UInt, column: UInt) -> CGPoint {
        let x = padding * CGFloat(column + 1) + tileSize.height * CGFloat(column)
        let y = padding * CGFloat(row + 1)    + tileSize.width  * CGFloat(row)
        return CGPoint(x: x, y: y)
    }
    
    override func draw(_ rect: CGRect) {
        layer.backgroundColor = Board2048View.bgBoardColor.cgColor
        layer.cornerRadius = cornerRadius
        bounds.size.height = bounds.size.width
        
        //draw empty places for tiles
        for row in 0..<size {
            for column in 0..<size {
                self.insertSubview(self[row, column], at: 0)
            }
        }
    }
}
