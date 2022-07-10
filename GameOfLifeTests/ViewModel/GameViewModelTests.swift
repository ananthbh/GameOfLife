//
//  GameViewModelTests.swift
//  GameOfLifeTests
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import XCTest

class GameViewModelTests: XCTestCase {

    // MARK: Subject under test
    
    private var sut: GameViewModelLogic!
    private var delegate: GameViewControllerUIDelegateSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        delegate = GameViewControllerUIDelegateSpy()
        /// a 3x3 sized board for easy testing.
        sut = GameViewModelLogic(size: 3)
        sut.delegate = delegate
        sut.setBoardToInitial()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: TestDelegate execution
    
    func test_givenViewModel_whenStartGameIsCalled_thenUpdateUIIsCalled() {
        sut.startGame(for: 1)
        XCTAssertTrue(delegate.updateUICalled)
    }
    
    func test_givenViewModel_whenSetBoardToInitialIsCalled_thenUpdateUIIsCalled() {
        sut.setBoardToInitial()
        XCTAssertTrue(delegate.updateUICalled)
    }
    
    func test_givenViewModel_whenStartGameIsCalled_thenGameOngoingIsTrue() {
        sut.startGame(for: 3)
        XCTAssertTrue(sut.gameOngoing)
    }
}

private final class GameViewControllerUIDelegateSpy: GameViewControllerUIDelegate {
    var updateUICalled = false
    var mockCells = [Cell]()
    
    func updateUI(cells: [Cell], currentGeneration: Int) {
        updateUICalled = true
        mockCells = cells
    }
}

