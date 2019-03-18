//
//  game2048.swift
//  2048
//
//  Created by Ilya Abdullin on 14/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import Foundation

class Tile2048 {
    var value: Int
    
    static func getRandomValueForNewTile() -> Int {
        return [2, 2, 2, 2, 2, 2, 2, 4].randomElement()!
    }
    
    init(value: Int) {
        self.value = value
    }
    
    convenience init(power: Int) {
        self.init(value: Int(2.pow(Double(power))))
    }
}

class Game2048 {
    
    var gameBoardSize: Int { //size of game board
        didSet {
            // TODO: what does do here?
        }
    }
    
    private(set) var tiles: [Int?] //all tiles on the game board
    
    //tiles with grouping on rows in two-dimensional array
    var rows: [[Int?]] {
        get {
            var tileRows = [[Int?]]()
            
            for rowIndex in 0..<gameBoardSize {
                tileRows.append([Int?]())
                
                for columnIndex in 0..<gameBoardSize {
                    tileRows[rowIndex].append(tiles[columnIndex + rowIndex * gameBoardSize])
                }
            }
            
            return tileRows
        }
        
        set {
            for rowIndex in 0..<gameBoardSize {
                for columnIndex in 0..<gameBoardSize {
                    tiles[columnIndex + rowIndex * gameBoardSize] = newValue[rowIndex][columnIndex]
                }
            }
        }
    }
    
    //tiles with grouping on columns in two-dimensional array
    var columns: [[Int?]] {
        get {
            var tileColumns = [[Int?]]()
            
            for columnIndex in 0..<gameBoardSize {
                tileColumns.append([Int?]())
                
                for rowIndex in 0..<gameBoardSize {
                    tileColumns[columnIndex].append(tiles[columnIndex + rowIndex * gameBoardSize])
                }
            }
            
            return tileColumns
        }
        
        set {
            for columnIndex in 0..<gameBoardSize {
                for rowIndex in 0..<gameBoardSize {
                    tiles[columnIndex + rowIndex * gameBoardSize] = newValue[columnIndex][rowIndex]
                }
            }
        }
    }
    
    func addNewRandomTile() -> Array<Int?>.Index {
        let randomIndex = tiles.indices.filter{tiles[$0] == nil}.randomElement()!
        tiles[randomIndex] = Tile2048.getRandomValueForNewTile()
        return randomIndex
    }
    
    func shiftTiles(to direction: Game2048.swipeDirection) {
        var lineOfTiles: [[Int?]]

        switch direction { //getting tiles like rows or columns depending of shifts direction
        case .up, .down:
            lineOfTiles = columns
        case .left, .right:
            lineOfTiles = rows
        }

        for lineIndex in 0..<gameBoardSize { //shifting each tiles line
            lineOfTiles[lineIndex] = shiftTilesLine(for: lineOfTiles[lineIndex], to: direction)
        }
        
        switch direction { //setting shifted lines back
        case .up, .down:
            columns = lineOfTiles
        case .left, .right:
            rows = lineOfTiles
        }
    }
    
    private func shiftTilesLine(for lineOfTiles: [Int?], to direction: swipeDirection) -> [Int?] {
        var line = lineOfTiles
        
        if direction == .down || direction == .right { //reversing array if direction of shift isn't equal to direction of next sorting
            line.reverse()
        }
        
        //shifting tiles with value to begin of line, using whatever is like a bubble sort
        var firstIndexWithTile = line.indices.filter{ line[$0] != nil }.first
        
        while firstIndexWithTile != nil {
            let firstIndexWithoutTile = line.indices.filter{ line[$0] == nil && $0 < firstIndexWithTile! }.first
            
            if firstIndexWithoutTile != nil {
                line.swapAt(firstIndexWithTile!, firstIndexWithoutTile!)
            }
            
            firstIndexWithTile = line.indices.filter{ line[$0] != nil && $0 > firstIndexWithTile! }.first
        }
        
        if direction == .down || direction == .right { //reversing array back
            line.reverse()
        }
        
        return line
    }
    
    func mergeNearbyEqualTiles(to direction: Game2048.swipeDirection) {
        // TODO: implement func shiftTiles
        
    }
    
    init(boardSize gameBoardSize: Int = 4) {
        self.gameBoardSize = gameBoardSize
        tiles = [Int?](repeating: nil, count: gameBoardSize * gameBoardSize) //fill tiles with nils
    }
}

//supporting funcs
extension Game2048 {
    enum swipeDirection {
        case up, down, left, right
    }
}

extension Int {
    func pow (_ power: Double) -> Double {
        return Foundation.pow(Double(self), power)
    }
}
