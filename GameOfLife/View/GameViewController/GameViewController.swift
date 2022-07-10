//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import UIKit

protocol GameViewControllerUIDelegate {
    func updateUI(cells: [Cell], currentGeneration: Int)
}

final class GameViewController: UIViewController {
    
    // MARK: Init
    
    private var viewModel: GameViewModel!
    
    init(viewModel: GameViewModel) {
         self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var boardView: BoardView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var infoLabel: UILabel!
    
    /// Game should run for 3 generations.
    private let numberOfGenerationsToRun = 3;
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialUI()
        setupInitialBoard()
    }

    // MARK: Actions
    
    @IBAction private func startAction(_ sender: Any) {
        guard !viewModel.gameOngoing else { return }
        startGame()
    }
    
    @IBAction private func resetAction(_ sender: Any) {
        guard !viewModel.gameOngoing else { return }
        setupInitialBoard()
    }
}

extension GameViewController: GameViewControllerUIDelegate {
    func updateUI(cells: [Cell], currentGeneration: Int) {
        /// update board UI.
        boardView.updateView(cells: cells)
        
        /// update info label.
        if (currentGeneration == 0) {
            /// reset or initial state if currentGen is 0.
            infoLabel.text = "Tap on Start button below"
            return
        }
        infoLabel.text = "Generation \(currentGeneration)"
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
    
    private func setupInitialBoard() {
        viewModel.setBoardToInitial()
    }
    
    private func startGame() {
        viewModel.startGame(for: numberOfGenerationsToRun)
    }
}
