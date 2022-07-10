//
//  BoardView.swift
//  GameOfLife
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import UIKit

final class BoardView: UIView {
    private var cellSize: Int = 0
    // hardcoding  10x10 size.
    private let cellsCount = 10
    
    private var cells = [Cell]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        start()
    }
    
    // MARK: UI
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()

        for cell in cells {
            let rect = CGRect(x: cell.x * cellSize, y: cell.y * cellSize, width: cellSize, height: cellSize)
            let color = cell.state == .live ? UIColor.green.cgColor : UIColor.red.cgColor
            context?.addRect(rect)
            context?.setFillColor(color)
            context?.fill(rect)
        }

        context?.restoreGState()
    }
}

extension BoardView {
    /// update view
    public func updateView(cells: [Cell]) {
        self.cells = cells;
    }
}

private extension BoardView {
    /// setup intial cells
    private func start() {
        let screenWidth = UIScreen.main.bounds.width
        cellSize = Int((screenWidth / CGFloat(cellsCount + 1)).rounded(.up))
        let frame = CGRect(x: 0, y: 0, width: cellSize, height: cellSize)
        self.frame = frame
    }
}
