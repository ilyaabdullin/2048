//
//  game2048.swift
//  2048
//
//  Created by Ilya Abdullin on 14/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import Foundation

class Game2048 {
    
    var gameBoardSize: Int = 4 { //size of game board
        didSet {
            //
        }
    }
    
    var tiles: [Int?]
    
    var rows: [[Int?]] { // TODO: implement var rows
//        var out = [[Int?]]()
//
//        for index in 0..<gameBoardSize {
//
//        }
        
        return [[Int?]]()
    }
    
    var columns: [[Int?]] { // TODO: implement var columns
        
        return [[Int?]]()
    }
    
    init(boardSize gameBoardSize: Int = 4) {
        self.gameBoardSize = gameBoardSize
        tiles = [Int?](repeating: nil, count: gameBoardSize * gameBoardSize) //fill tiles with nils
    }

    func addRandomTile() {
        let randomIndex = tiles.indices.filter{tiles[$0] == nil}.randomElement()!
        tiles[randomIndex] = getRandomTile2048Value()
    }
}



//supporting funcs
extension Game2048 {
    private func getPowerOf2 (power: Int) -> Int {
        return Int(2.pow(Double(power)))
    }
    
    private func getRandomTile2048Value() -> Int {
        return [2, 2, 2, 2, 2, 2, 2, 4].randomElement()!
    }
}

extension Int {
    func pow (_ power: Double) -> Double {
        return Foundation.pow(Double(self), power)
    }
}
