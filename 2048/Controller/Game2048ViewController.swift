//
//  Game2048ViewController.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

class Game2048ViewController: UIViewController {
    
    @IBOutlet weak var board2048View: Board2048View!
    
    private var game: Game2048!
    
    var boardSize = 10
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //send animation properties to board2048View
        board2048View.durationOfMovingToOneTileAnimation = durationOfMovingToOneTileAnimation
        board2048View.maxDurationOfMoving = maxDurationOfMoving
        board2048View.showingAndMergingTileDuration = showingAndMergingTileDuration
        
        runNewGame();
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
        addNewRandomTile()
        addNewRandomTile()
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        shiftMergeAndAddNewTile(to: .up)
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        shiftMergeAndAddNewTile(to: .down)
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        shiftMergeAndAddNewTile(to: .left)
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        shiftMergeAndAddNewTile(to: .right)
    }
}

//methods for manipulating tiles
extension Game2048ViewController {

    private func addNewRandomTile() {
        if let randomTileEmptyPlace = board2048View.tilePlaces.filter({ $0.tiles.count == 0 }).randomElement() {
            let tile = Tile2048(value: Tile2048.getRandomValueForNewTile())
            
            board2048View.add(tile: tile, to: randomTileEmptyPlace)
        }
    }
    
    func shiftMergeAndAddNewTile(to direction: UISwipeGestureRecognizer.Direction) {
        if shiftTilesWithMerging(to: direction) {
            addNewRandomTile()
        }
    }
    
    func mergeTiles() {
        board2048View.tilePlaces.filter{ $0.tiles.count>1 }.forEach { (tilePlaceWithTileForMerging) in
            board2048View.mergeTiles(in: tilePlaceWithTileForMerging)
        }
    }
    
    func shiftTilesWithMerging(to direction: UISwipeGestureRecognizer.Direction) -> Bool {
        var isShifted = false
        
        for lineIndex in 0..<boardSize {
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
            let nextTileForShifting = nextTilePlaceWithTileForShifting!.tiles.first!
            let nextTilePlaceWithTileForShiftingIndex = line.firstIndex(of: nextTilePlaceWithTileForShifting!)!
            var targetPlace: TilePlace2048View?
            
            if let lastNonEmptyTilePlaceOnTheLeft = line.filter({ $0.tiles.count == 1 && line.firstIndex(of: $0)! < nextTilePlaceWithTileForShiftingIndex}).last { //getting nearest tile place with tile on the left of current tile
                if lastNonEmptyTilePlaceOnTheLeft.tiles.first!.value == nextTileForShifting.value {
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
}
