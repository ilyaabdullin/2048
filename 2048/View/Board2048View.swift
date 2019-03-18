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
    
    var tilePlaces = [UIView]()

    override func draw(_ rect: CGRect) {
        layer.backgroundColor = Board2048View.bgBoardColor.cgColor
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layer.cornerRadius = cornerRadius
        bounds.size.height = bounds.size.width
        
        //draw empty places for tiles
        for row in 0..<size {
            for column in 0..<size {
                self.insertSubview(self[row, column], at: 100)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fillTilePlaces()
    }
    
    private func fillTilePlaces() {
        tilePlaces.removeAll(keepingCapacity: false)
        
        for row in 0..<size {
            for column in 0..<size {
                let tilePlace = UIView(frame: CGRect(origin: getTileMinXMinYPoint(row: UInt(row), column: UInt(column)), size: tileSize))
                tilePlace.layer.backgroundColor = Board2048View.bgEmptyTileColor.cgColor
                tilePlace.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                tilePlace.layer.cornerRadius = cornerRadius
                tilePlaces.append(tilePlace)
            }
        }
    }
}

//methods and subscript for navigation (getting and setting) tiles and row and column tiles
extension Board2048View {
    
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < tilePlaces.count / size && column >= 0 && column < tilePlaces.count / size
    }
    
    subscript(row: Int, column: Int) -> UIView {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            
            return tilePlaces[(row * size) + column]
        }
//        set {
//            assert(indexIsValid(row: row, column: column), "Index out of range")
//
//            tilePlaces[(row * size) + column] = newValue
//        }
    }
    
    func getColumn(by rowIndex: Int) -> [UIView] {
        var tileRow = [UIView]()
        
        for columnIndex in 0..<size {
            tileRow.append(self[rowIndex, columnIndex])
        }
        
        return tileRow
    }
    
//    func setColumn(by rowIndex: Int, withValues row: [UIView]) {
//        for columnIndex in 0..<size {
//            self[rowIndex, columnIndex] = row[columnIndex]
//        }
//    }
    
    func getRow(by columnIndex: Int) -> [UIView] {
        var tileColumn = [UIView]()
        
        for rowIndex in 0..<size {
            tileColumn.append(self[rowIndex, columnIndex])
        }
        
        return tileColumn
    }
    
//    func setRow(by columnIndex: Int, withValues column: [UIView]) {
//        for rowIndex in 0..<size {
//            self[rowIndex, columnIndex] = column[rowIndex]
//        }
//    }
    
    func getLine(by lineIndex: Int, to direction: UISwipeGestureRecognizer.Direction) -> [UIView] {
        switch direction {
        case .left, .right:
            return getRow(by: lineIndex)
        default:
            return getColumn(by: lineIndex)
        }
    }
    
//    func setLine(by lineIndex: Int, withValues line: [UIView], to direction: UISwipeGestureRecognizer.Direction) {
//        switch direction {
//        case .left, .right:
//            setRow(by: lineIndex, withValues: line)
//        default:
//            setColumn(by: lineIndex, withValues: line)
//        }
//    }
}

//constants, variables and funcs for drawing
extension Board2048View {
    
    static let bgBoardColor = #colorLiteral(red: 0.7352144122, green: 0.6780939698, blue: 0.6294513941, alpha: 1)
    static let bgEmptyTileColor = #colorLiteral(red: 0.8055974841, green: 0.7564521432, blue: 0.7078657746, alpha: 1)
    
    private var padding: CGFloat {
        return bounds.size.width / CGFloat(11 * size + 1)
    }
    
    var tileSize: CGSize {
        return CGSize(width: padding * 10, height: padding * 10)
    }
    
    var cornerRadius: CGFloat {
        return tileSize.height * 0.05
    }
    
    private func getTileMinXMinYPoint(row: UInt, column: UInt) -> CGPoint {
        let x = padding * CGFloat(row + 1) + tileSize.width * CGFloat(row)
        let y = padding * CGFloat(column + 1) + tileSize.height * CGFloat(column)
        return CGPoint(x: x, y: y)
    }
}
