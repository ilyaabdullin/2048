//
//  ViewController.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

class Game2048ViewController: UIViewController {
    
    @IBOutlet weak var board2048View: Board2048View!
    
    private var game: Game2048!
    
    var boardSize = 4
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        runNewGame();
    }
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
        if shiftTiles(to: direction) {
            mergeTiles()
            addNewRandomTile()
        }
    }
    
    func mergeTiles() {
        
    }
    
    func shiftTiles(to direction: UISwipeGestureRecognizer.Direction) -> Bool {
        var isShifted = false
        
        for lineIndex in 0..<board2048View.size {
            isShifted = isShifted || shiftTileLine(at: lineIndex, direction: direction)
        }
        
        return isShifted
    }
    
    func shiftTileLine(at lineIndex: Int, direction: UISwipeGestureRecognizer.Direction) -> Bool {
        var isShifted = false
        
        var line = board2048View.getLine(by: lineIndex, to: direction)
        
        if direction == .down || direction == .right { //reversing array if direction of shift isn't equal to direction of next sorting
            line.reverse()
        }
        
        //shifting tiles with value to begin of line, using whatever is like a bubble sort
        var nextTilePlaceWithTileForShifting = line.filter{ $0.tiles.count == 1 && line.firstIndex(of: $0)! > 0 }.first
        
        while nextTilePlaceWithTileForShifting != nil  {
            let nextTileForShifting = nextTilePlaceWithTileForShifting!.tiles.first!
            if let targetEmptyTilePlace = line.filter({
                ( $0.tiles.count == 0 && line.firstIndex(of: $0)! < line.firstIndex(of: nextTilePlaceWithTileForShifting!)! )
                    || ( $0.subviews.count == 1 && ($0.tiles.first!).value == nextTileForShifting.value )
            }).first {
                board2048View.moveTile(from: nextTilePlaceWithTileForShifting!, to: targetEmptyTilePlace, withDurationPerTile: Game2048ViewController.durationOfOneTileAnimation)
                isShifted = true
            }
            
            nextTilePlaceWithTileForShifting = line.filter{ $0.tiles.count == 1 && line.firstIndex(of: $0)! > line.firstIndex(of: nextTilePlaceWithTileForShifting!)! }.first
        }
        //end of shifting tiles to begin
        
        return isShifted
    }
}

//animation duration constants
extension Game2048ViewController {
    
    static var durationOfOneTileAnimation: TimeInterval = 0.1
    static var showingTileDuration: TimeInterval = 0.25
}
