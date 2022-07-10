//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import UIKit

final class GameViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var boardView: BoardView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialUI()
    }

    // MARK: Actions
    
    @IBAction private func startAction(_ sender: Any) {
    }
    
    @IBAction private func resetAction(_ sender: Any) {
    }
    
}

private extension GameViewController {
    private func setupInitialUI() {
        self.navigationItem.title = "Game of Life"
        
        infoLabel.text = "Tap on Start button below"
        
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        resetButton.layer.borderWidth = 1.0
        resetButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
}
