//
//  GameViewModel.swift
//  GameOfLife
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import Foundation

protocol GameViewModel {
    func setBoardToInitial()
    func startGame(for generations: Int)
    var gameOngoing: Bool { get }
}

final class GameViewModelLogic {
    private var cells = [Cell]()
    /// 10 x10 game board.
    private var size: Int = 10
    private var boardActionInProcess = false;
    
    var delegate: GameViewControllerUIDelegate?
    
    init(size: Int = 10) {
        self.size = size;
        setBoardToInitial()
    }
}

extension GameViewModelLogic: GameViewModel {
    /// setup initial cells or reset the cells.
    public func setBoardToInitial() {
        (0..<size).forEach { x in
            (0..<size).forEach { y in
                let randomInt = Int.random(in: 0...5)
                let cell = Cell(x: x, y: y, state: randomInt == 0 ? .live : .dead)
                cells.append(cell)
            }
        }
        
        delegate?.updateUI(cells: cells, currentGeneration: 0)
        
        /// reset the game ongoing flag.
        boardActionInProcess = false;
    }
    
    /// triggered when user starts the game.
    public func startGame(for generations: Int) {
        boardActionInProcess = true
        runBoard(for: generations)
    }
    
    public var gameOngoing: Bool {
        return boardActionInProcess
    }
}

private extension GameViewModelLogic {
    /// This method is created so that there is an elegant way to run each generation and give enough time for the user to see the changes  in UI after each generation.
    private func runBoard(for generations: Int) {
        var generationIndex = 0

        func nextIteration() {
            if generationIndex < generations {
                let updatedCells = updateBoardForGeneration();
                let currentGenerationValue = generationIndex + 1
                delegate?.updateUI(cells: updatedCells, currentGeneration: currentGenerationValue)
                
                generationIndex += 1

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                    nextIteration()
                    if (generationIndex == generations) {
                        self?.boardActionInProcess = false
                    }
                }
            }
        }

        nextIteration()
    }
    
    private func updateBoardForGeneration() -> [Cell] {
        let cellsLive = cells.filter({ $0.state == .live })
        
        for i in 0..<cells.count {
            /// get the current cell.
            var cell = cells[i]
            
            /// get the current cell's neighbours that are live.
            let neighboursLive = cellsLive.filter({ $0.isNeighbours(cell) })
            
            if cell.state == .live {
                if neighboursLive.count == 2 || neighboursLive.count == 3 {
                    /// cell have 2 or 3 live neighbours. so it can stay live.
                    cell.state = .live
                    cells[i] = cell
                } else {
                    /// all live cells die in the next generation.
                    cell.state = .dead
                    cells[i] = cell
                }
            } else {
                /// dead cell with 3 neighbours can stay alive.
                if neighboursLive.count == 3 {
                    cell.state = .live
                    cells[i] = cell
                }
            }
        }
        return cells;
    }
}
