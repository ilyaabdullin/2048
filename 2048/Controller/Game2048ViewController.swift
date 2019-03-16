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
    
    private var viewBoardSize: Int { //count of tileViews in row or column (hope the form of views is a square)
        return Int(sqrt(Double(tileViews.count)))
    }
    
    private var game: Game2048!
    
    var boardSize = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runNewGame();
    }
}

//gameplay
extension Game2048ViewController {
    func runNewGame() {
        game = Game2048(boardSize: boardSize)
        updateViewFromModelGame2048()
        
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
    
    private struct animationDuration {
        static var show = 0.3
    }
    
    private func updateViewFromModelGame2048() {
        for x in 0..<boardSize {
            for y in 0..<boardSize {
                let tile = game.tiles[y + x * boardSize]
                tileViews[y + x * viewBoardSize].value = tile
            }
        }
        
        //        if tileViews.filter( { $0.isHidden } ).count != boardSize * boardSize {
        //            for x in 0..<viewBoardSize {
        //                for y in 0..<viewBoardSize {
        //                    if x > boardSize || y > boardSize {
        //                        tileViews[y + x * viewBoardSize].isHidden = true
        //                    }
        //                }
        //            }
        //        }
    }
    
    private func addNewRandomTile() {
        let tileIndex = game.addNewRandomTile()
        updateOneTile2048View(for: tileIndex)
    }
    
    private func updateOneTile2048View(for tileIndex: Array<Int?>.Index) {
        let tile = game.tiles[tileIndex]
        let tileView = tileViews[tileIndex]
        tileView.value = tile
        tileView.show(duration: animationDuration.show)
    }
    
    //the process of shifting tiles has 3 step
    //for example we have next 8 tiles row 2  ⃞ 2  ⃞ 2  ⃞ 2 and we shifting that to RIGHT
    //on step 1 shifting all tiles to right: 2  ⃞ 2  ⃞ 2  ⃞ 2 →  ⃞  ⃞  ⃞  ⃞ 2 2 2 2
    //on step 2 merging (with summing the values) all nearby equal tiles with shift to right:  ⃞  ⃞  ⃞  ⃞ 2 2 2 2 →  ⃞  ⃞  ⃞  ⃞  ⃞ 4  ⃞ 4
    //on step 3 shifting all tiles to right again:  ⃞  ⃞  ⃞  ⃞  ⃞ 4  ⃞ 4 →  ⃞  ⃞  ⃞  ⃞  ⃞  ⃞ 4 4
    private func shiftTiles(to direction: Game2048.swipeDirection) {
        game.shiftTiles(to: direction)
        game.mergeNearbyEqualTiles(to: direction)
        //game.shiftTiles(to: direction)
        
        updateViewFromModelGame2048()
    }
}

//another stuff and supporting
extension Game2048ViewController {
    
    
}
