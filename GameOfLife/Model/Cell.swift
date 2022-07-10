//
//  Cell.swift
//  GameOfLife
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import Foundation

enum State {
    case live
    case dead
}

struct Cell {
    let x: Int
    let y: Int
    var state: State
    
    func isNeighbours(_ cell: Cell) -> Bool {
        let deltaX = abs(x - cell.x)
        let deltaY = abs(y - cell.y)
        
        switch (deltaX, deltaY) {
        case (1, 1), (0, 1), (1, 0):
            return true
        default:
            return false
        }
    }
}

extension Cell: Equatable { }
