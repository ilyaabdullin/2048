//
//  tile2048.swift
//  2048
//
//  Created by Ilya Abdullin on 08/03/2019.
//  Copyright © 2019 Ilya Abdullin. All rights reserved.
//

import Foundation

struct Tile2048 {
    var value: Int
    
    init(power: Int) {
        value = Int(2.pow(Double(power)))
    }
    
    init(value: Int) {
        self.value = value
    }
}

extension Int {
    func pow (_ power: Double) -> Double {
        return Foundation.pow(Double(self), power)
    }
}
