//
//  GameViewModelTests.swift
//  GameOfLifeTests
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import XCTest

final class GameViewModelTests: XCTestCase {

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
    
    // MARK: Test Logic
    
    func test_givenViewModel_whenStartGameIsCalled_thenCellsAreUpdated() {
        let mirror = Mirror(reflecting: sut.self!)
        sut.startGame(for: 3)
        let currentViewModelCells: [Cell] = mirror.children.first(where: { $0.label == "cells" })?.value as! [Cell]
        XCTAssertEqual(currentViewModelCells, delegate.mockCells)
    }
    
    func test_givenViewModel_whenResetIsCalled_thenCellsAreUpdated() {
        let mirror = Mirror(reflecting: sut.self!)
        sut.setBoardToInitial()
        let currentViewModelCells: [Cell] = mirror.children.first(where: { $0.label == "cells" })?.value as! [Cell]
        XCTAssertEqual(currentViewModelCells, delegate.mockCells)
    }
    
    func test_givenViewModel_whenStartGameIsCalled_thenGameOngoingIsFalse() {
        sut.startGame(for: 1)
        XCTAssertEqual(sut.gameOngoing, true)
        
        let expectation = expectation(description: "Wait for main thread async after to execute")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertFalse(sut.gameOngoing)
    }
    
    func test_givenViewModel_whenStartGameIsCalled_thenMatchCells() {
        // execute test case from https://leetcode.com/problems/game-of-life/
        let initialCells: [Cell] = [
            Cell(x: 0, y: 0, state: .dead),
            Cell(x: 0, y: 1, state: .live),
            Cell(x: 0, y: 2, state: .dead),
            Cell(x: 1, y: 0, state: .dead),
            Cell(x: 1, y: 1, state: .dead),
            Cell(x: 1, y: 2, state: .live),
            Cell(x: 2, y: 0, state: .live),
            Cell(x: 2, y: 1, state: .live),
            Cell(x: 2, y: 2, state: .live),
            Cell(x: 3, y: 0, state: .dead),
            Cell(x: 3, y: 1, state: .dead),
            Cell(x: 3, y: 2, state: .dead)
        ]
        
        let resultCells: [Cell] = [
            Cell(x: 0, y: 0, state: .dead),
            Cell(x: 0, y: 1, state: .dead),
            Cell(x: 0, y: 2, state: .dead),
            Cell(x: 1, y: 0, state: .live),
            Cell(x: 1, y: 1, state: .dead),
            Cell(x: 1, y: 2, state: .live),
            Cell(x: 2, y: 0, state: .dead),
            Cell(x: 2, y: 1, state: .live),
            Cell(x: 2, y: 2, state: .live),
            Cell(x: 3, y: 0, state: .dead),
            Cell(x: 3, y: 1, state: .live),
            Cell(x: 3, y: 2, state: .dead)
        ]
        
        sut.setInitialCells(cells: initialCells)
        sut.startGame(for: 1)
        
        XCTAssertEqual(resultCells, delegate.mockCells)
    }
    
    func test_givenViewModel_whenStartGameIsCalled_thenMatchCells2() {
        // execute test case from https://leetcode.com/problems/game-of-life/
        let initialCells: [Cell] = [
            Cell(x: 0, y: 0, state: .live),
            Cell(x: 0, y: 1, state: .live),
            Cell(x: 1, y: 0, state: .live),
            Cell(x: 1, y: 1, state: .dead)
        ]
        
        let resultCells: [Cell] = [
            Cell(x: 0, y: 0, state: .live),
            Cell(x: 0, y: 1, state: .live),
            Cell(x: 1, y: 0, state: .live),
            Cell(x: 1, y: 1, state: .live)
        ]
        
        sut.setInitialCells(cells: initialCells)
        sut.startGame(for: 1)
        
        XCTAssertEqual(resultCells, delegate.mockCells)
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

