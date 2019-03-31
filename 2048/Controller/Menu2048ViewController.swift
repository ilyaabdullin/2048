//
//  Menu2048ViewController.swift
//  2048
//
//  Created by Ilya Abdullin on 22/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import UIKit

class Menu2048ViewController: UIViewController {

    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet var boardSizeLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = UserDefaults.standard.array(forKey: "game2048Board") as? [Int] {
            resumeButton.isHidden = false
        }
    }
    
    @IBAction func decreaseBoardSize(_ sender: Any) {
        if let curValue = Int(boardSizeLabels?.first?.text ?? "0") {
            boardSizeLabels.forEach { (label) in
                UIView.transition(with: label, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromRight], animations: {
                    if curValue > 1 {
                        label.text = String(curValue - 1)
                    }
                }, completion: nil)
            }
        }
    }
    
    @IBAction func increaseBoardSize(_ sender: Any) {
        if let curValue = Int(boardSizeLabels?.first?.text ?? "99") {
            if curValue < 8 {
                boardSizeLabels.forEach { (label) in
                    UIView.transition(with: label, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromLeft], animations: {
                        if curValue < 8 {
                            label.text = String(curValue + 1)
                        }
                    }, completion: nil)
                    
                }
            }
        }
    }
    
    @IBAction func letsStart(_ sender: UIButton) {
        performSegue(withIdentifier: "startGame", sender: sender)
        resumeButton.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            if let button = sender as? UIButton, let game2048VC = segue.destination as? Game2048ViewController {
                if button.titleLabel?.text == "New game" {
                    game2048VC.isNewGame = true
                }
                game2048VC.boardSize = Int(boardSizeLabels!.first!.text!) ?? 4
            }
            
        }
    }
}
