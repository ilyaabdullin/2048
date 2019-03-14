//
//  tile2048.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import Foundation

extension Int {
    func pow (_ power: Double) -> Double {
        return Foundation.pow(Double(self), power)
    }
    
    func get2Pow (power: Int) -> Int {
        return Int(2.pow(Double(power)))
    }
    
    func getRandomTile2048Value() -> Int {
        return [2, 2, 2, 2, 2, 2, 2, 4].randomElement()!
    }
}
