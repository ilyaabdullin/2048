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
    
    enum swipeDirection {
        case up, down, left, right
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        addNewRandomTile()
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        addNewRandomTile()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        addNewRandomTile()
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        addNewRandomTile()
    }
}

//animation and model to view logic
extension Game2048ViewController {
    
    struct animationDuration {
        static var show = 0.3
    }
    
    func updateViewFromModelGame2048() {
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
    
    func addNewRandomTile() {
        let tileIndex = game.addNewRandomTile()
        updateOneTile2048View(for: tileIndex)
    }
    
    func updateOneTile2048View(for tileIndex: Array<Int?>.Index) {
        let tile = game.tiles[tileIndex]
        let tileView = tileViews[tileIndex]
        tileView.value = tile
        tileView.show(duration: animationDuration.show)
    }
}
