//
//  Game2048ViewController.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

class Game2048ViewController: UIViewController, UIApplicationDelegate {
    
    @IBOutlet weak var board2048View: Board2048View!
    
    private var game: Game2048!
    
    @IBOutlet weak var gameOverLabel: UILabel!
    
    @IBOutlet weak var tryAgainButton: Button2048View!
    
    var boardSize = 4 { didSet{ board2048View?.size = boardSize } }
    
    var isNewGame = false
    
    override func viewDidLoad() {
        board2048View.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        board2048View.size = boardSize
        super.viewDidAppear(animated)
        
        //send animation properties to board2048View
        board2048View.durationOfMovingToOneTileAnimation = durationOfMovingToOneTileAnimation
        board2048View.maxDurationOfMoving = maxDurationOfMoving
        board2048View.showingAndMergingTileDuration = showingAndMergingTileDuration
        
        if isNewGame || !loadGameData() { //load game if it's not a resuming
            runNewGame()
        }
    }
    
    //animation duration properties
    var durationOfMovingToOneTileAnimation: TimeInterval = 0.05
    var maxDurationOfMoving: TimeInterval = 0.4
    var showingAndMergingTileDuration: TimeInterval { return durationOfMovingToOneTileAnimation * 5 }
}

//gameplay
extension Game2048ViewController {
    func runNewGame() {
        board2048View.size = boardSize
        gameOverLabel.isHidden = true
        tryAgainButton.isHidden = true
        board2048View.alpha = 1.0
        board2048View.isHidden = false
        
        addNewRandomTile()
        addNewRandomTile()
    }
    
    func gameOver() {
        self.gameOverLabel.alpha = 0.0
        self.tryAgainButton.alpha = 0.0
        self.gameOverLabel.isHidden = false
        self.tryAgainButton.isHidden = false
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
            self.board2048View.alpha = 0.33
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
            self.gameOverLabel.alpha = 1.0
            self.tryAgainButton.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        if !isGameOver() {
            shiftMergeAndAddNewTile(to: .up)
        }
        
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        if !isGameOver() {
            shiftMergeAndAddNewTile(to: .down)
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if !isGameOver() {
            shiftMergeAndAddNewTile(to: .left)
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if !isGameOver() {
            shiftMergeAndAddNewTile(to: .right)
        }
    }
    
    @IBAction func pushNewGameButton(_ sender: UIButton) {
        runNewGame()
    }

    @IBAction func backToMenu(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//methods for manipulating tiles
extension Game2048ViewController {

    private func addNewRandomTile() {
        if let randomTileEmptyPlace = board2048View.tilePlaces.filter({ $0.tiles.count == 0 }).randomElement() {
            let tile = Tile2048(value: Tile2048.getRandomValueForNewTile())
            
            board2048View.add(tile: tile, to: randomTileEmptyPlace)
        }
        
        if isGameOver() {
            gameOver()
        }
    }
    
    func shiftMergeAndAddNewTile(to direction: UISwipeGestureRecognizer.Direction) {
        if shiftTilesWithMerging(to: direction) {
            addNewRandomTile()
            saveGameData()
        }
        else {
            board2048View.tilePlaces.map({ $0.tiles.first }).forEach { (tile) in
                tile?.startFailedShifting(to: direction, withDuration: showingAndMergingTileDuration)
                tile?.startShakeAnimation(withDuration: showingAndMergingTileDuration)
            }
        }
    }
    
    func shiftTilesWithMerging(to direction: UISwipeGestureRecognizer.Direction) -> Bool {
        var isShifted = false
        
        for lineIndex in 0..<board2048View.size {
            let currentLineIsShifted = shiftTileLineWithMerging(at: lineIndex, direction: direction)
            isShifted = isShifted || currentLineIsShifted
        }
        
        return isShifted
    }
    
    func shiftTileLineWithMerging(at lineIndex: Int, direction: UISwipeGestureRecognizer.Direction) -> Bool {
        var isShifted = false
        
        var line = board2048View.getLine(by: lineIndex, to: direction)
        
        if direction == .down || direction == .right { //is reversing array if direction of shifting isn't equal to direction of next sorting of tiles line (from end to begin)
            line.reverse()
        }
        
        //start of shifting tiles to begin of line
        var nextTilePlaceWithTileForShifting = line.filter{ $0.tiles.count == 1 && line.firstIndex(of: $0)! > 0 }.first
        while nextTilePlaceWithTileForShifting != nil {
            let nextTilePlaceWithTileForShiftingIndex = line.firstIndex(of: nextTilePlaceWithTileForShifting!)!
            var targetPlace: TilePlace2048View?
            
            if let lastNonEmptyTilePlaceOnTheLeft = line.filter({ $0.tiles.count > 0 && line.firstIndex(of: $0)! < nextTilePlaceWithTileForShiftingIndex}).last { //getting nearest tile place with tile on the left of current tile
                if lastNonEmptyTilePlaceOnTheLeft.equalTo(tileRight: nextTilePlaceWithTileForShifting!) {
                    targetPlace = lastNonEmptyTilePlaceOnTheLeft //target place for moving tile on the place of tile twin with next merging
                }
            }
            
            if targetPlace == nil, let firstEmptyTilePlaceOnLeft = line.filter({ $0.tiles.count == 0 && line.firstIndex(of: $0)! < nextTilePlaceWithTileForShiftingIndex }).first { //getting outermost empty tile place if target place still not found
                targetPlace = firstEmptyTilePlaceOnLeft //target place for moving tile to empty place
            }
            
            if targetPlace != nil { //moving tile if getting target tile place and merging if this need
                board2048View.moveTileWithMerging(from: nextTilePlaceWithTileForShifting!, to: targetPlace!)

                isShifted = true
            }
            
            nextTilePlaceWithTileForShifting = line.filter{ $0.tiles.count == 1 && line.firstIndex(of: $0)! > nextTilePlaceWithTileForShiftingIndex }.first //getting next tile for supposed shifting
        }
        //end of shifting tiles to begin
        
        return isShifted
    }
    
    func mergeTiles() {
        board2048View.tilePlaces.filter{ $0.tiles.count>1 }.forEach { (tilePlaceWithTileForMerging) in
            board2048View.mergeTiles(in: tilePlaceWithTileForMerging)
        }
    }
}

// TODO: let's classificate this
extension Game2048ViewController {
    
    func isGameOver() -> Bool {
        
        if board2048View.tilePlaces.filter({ $0.tiles.count>0 }).count < board2048View.tilePlaces.count { //we have empty tile place on the board
            return false
        }
        
        for rowIndex in 0..<board2048View.size { //check equaling between each tile and its next in row
            let row = board2048View.getRow(by: rowIndex)
            for tilePlaceIndex in 0..<(board2048View.size - 1) {
                let curTilePlace = row[tilePlaceIndex]
                let nextTilePlace = row[tilePlaceIndex + 1]
                if curTilePlace.sumTiles == nextTilePlace.sumTiles  {
                    return false
                }
            }
        }
        
        for columnIndex in 0..<board2048View.size { //check equaling between each tile and its next in column
            let column = board2048View.getColumn(by: columnIndex)
            for tilePlaceIndex in 0..<(board2048View.size - 1) {
                let curTilePlace = column[tilePlaceIndex]
                let nextTilePlace = column[tilePlaceIndex + 1]
                if curTilePlace.sumTiles == nextTilePlace.sumTiles  {
                    return false
                }
            }
        }

        return true //no more moves left
    }
    
    func saveGameData() {
        let tiles = board2048View.tilePlaces.map{$0.sumTiles}
        UserDefaults.standard.set(tiles, forKey: "game2048Board")
    }
    
    func loadGameData() -> Bool {
        if let tiles = UserDefaults.standard.array(forKey: "game2048Board") as? [Int] {
            let size = Int(sqrt(Double(tiles.count)))
            if size * size == tiles.count && size > 0 {
                boardSize = size
                board2048View.isHidden = false
                
                //clear board
                for tilePlace in board2048View.tilePlaces {
                    board2048View.removeTiles(from: tilePlace)
                }
                
                for tileIndex in 0..<tiles.count {
                    let tileValue = tiles[tileIndex]
                    if tileValue != 0 {
                        let tile = Tile2048(value: tileValue)
                        board2048View.add(tile: tile, to: board2048View.tilePlaces[tileIndex])
                    }
                }
                
                if isGameOver() {
                    gameOver()
                }
                
                return true
            }
        }
        
        return false
    }
}
