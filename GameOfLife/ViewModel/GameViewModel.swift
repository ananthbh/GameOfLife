//
//  GameViewModel.swift
//  GameOfLife
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import Foundation

protocol GameViewModel {
    
}

final class GameViewModelLogic {
    
    var delegate: GameViewControllerUIDelegate?
}

extension GameViewModelLogic: GameViewModel {
    
}
