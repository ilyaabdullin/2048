//
//  ViewController.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

class Game2048ViewController: UIViewController {

    @IBOutlet var tileViews: [Tile2048View]!
    
    @IBOutlet weak var board2048View: Board2048View!
    
    private var viewBoardSize: Int { //count of tileViews in row or column (hope the form of views is a square)
        return Int(sqrt(Double(tileViews.count)))
    }
    
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
        //game = Game2048(boardSize: boardSize)
        //updateViewFromModelGame2048()
        board2048View.size = boardSize
        
        addNewRandomTile()
        addNewRandomTile()
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        shiftTiles(to: .up)
        addNewRandomTile()
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        shiftTiles(to: .down)
        addNewRandomTile()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        shiftTiles(to: .left)
        addNewRandomTile()
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        shiftTiles(to: .right)
        addNewRandomTile()
    }
}

//animation and logic for updating model to view
extension Game2048ViewController {
    
    //animation duration constants
    static var durationOfOneTileAnimation: TimeInterval = 0.1
    static var showingTileDuration: TimeInterval = 0.25
    var shiftingTileDuration: TimeInterval {
        return Game2048ViewController.durationOfOneTileAnimation * TimeInterval(boardSize / 2)
    }
    
    private func addNewRandomTile() {
        if let randomTileEmptyPlace = board2048View.tilePlaces.filter({ $0.subviews.count == 0 }).randomElement() {
            let tile = Tile2048(value: Tile2048.getRandomValueForNewTile())
            let tileView = Tile2048View.init(frame: randomTileEmptyPlace.bounds)
            tileView.tile2048 = tile
            
            randomTileEmptyPlace.insertSubview(tileView, at: 0)
            tileView.show(duration: Game2048ViewController.showingTileDuration)
        }
    }
    
    func shiftTiles(to direction: UISwipeGestureRecognizer.Direction) {
        
        for lineIndex in 0..<board2048View.size {
            shiftTileLine(at: lineIndex, direction: direction)
        }
    }
    
    //the process of shifting tiles has 3 step
    //for example we have next 8 tiles row 2  ⃞ 2  ⃞ 2  ⃞ 2  ⃞ and we shifting that to RIGHT
    //on step 1 shifting all tiles to right: 2  ⃞ 2  ⃞ 2  ⃞ 2  ⃞ →  ⃞  ⃞  ⃞  ⃞ 2 2 2 2
    //on step 2 merging (with summing the values) all nearby equal tiles with shift to right:  ⃞  ⃞  ⃞  ⃞ 2 2 2 2 →  ⃞  ⃞  ⃞  ⃞  ⃞ 4  ⃞ 4
    //on step 3 shifting all tiles to right again:  ⃞  ⃞  ⃞  ⃞  ⃞ 4  ⃞ 4 →  ⃞  ⃞  ⃞  ⃞  ⃞  ⃞ 4 4
//    private func shiftTiles(to direction: UISwipeGestureRecognizer.Direction) {
//        game.shiftTiles(to: direction) //step 1
//        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 7, options: .curveEaseOut, animations: {
//            self.updateViewFromModelGame2048()
//        }, completion: nil)
//
//        game.mergeNearbyEqualTiles(to: direction) //step 2
        //game.shiftTiles(to: direction) //step 3
//    }
}

//methods for shifting and merging tiles
extension Game2048ViewController {
    func shiftTileLine(at lineIndex: Int, direction: UISwipeGestureRecognizer.Direction) {
        
        var line = board2048View.getLine(by: lineIndex, to: direction)
        
        if direction == .down || direction == .right { //reversing array if direction of shift isn't equal to direction of next sorting
            line.reverse()
        }
        
        // MARK: shifting tiles with value to begin of line, using whatever is like a bubble sort
        var nextTilePlaceWithTileForShifting = line.filter{ $0.subviews.count == 1 && line.firstIndex(of: $0)! > 0 }.first
        
        while nextTilePlaceWithTileForShifting != nil  {
            let nextTileForShifting = nextTilePlaceWithTileForShifting!.subviews.first! as! Tile2048View
            let targetEmptyTilePlace = line.filter{
                ( $0.subviews.count == 0 && line.firstIndex(of: $0)! < line.firstIndex(of: nextTilePlaceWithTileForShifting!)! )
                    || ( $0.subviews.count == 1 && ($0.subviews.first! as! Tile2048View).value == nextTileForShifting.value )
                }.first
            
            if targetEmptyTilePlace != nil {
                nextTileForShifting.removeFromSuperview()
                targetEmptyTilePlace?.insertSubview(nextTileForShifting, at: 0)
            }
            
            nextTilePlaceWithTileForShifting = line.filter{ $0.subviews.count == 1 && line.firstIndex(of: $0)! > line.firstIndex(of: nextTilePlaceWithTileForShifting!)! }.first
        }
        // MARK: end of shifting tiles to begin
    }
    

}

//another stuff and supporting
extension Game2048ViewController {
    
    
}
