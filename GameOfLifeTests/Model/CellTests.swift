//
//  CellTests.swift
//  GameOfLifeTests
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import XCTest

class CellTests: XCTestCase {
    // MARK: Subject under test
    
    private var sut: Cell!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        sut = Cell(x: 0, y: 0, state: .live)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: Test
    
    func test_givenModel_whenIsNeighbourCalled_thenReturnsAValueTrue() {
        let result = sut.isNeighbours(Cell(x: 1, y: 1, state: .dead))
        
        XCTAssertTrue(result)
    }
    
    func test_givenModel_whenIsNeighbourCalled_thenReturnsAValueFalse() {
        let result = sut.isNeighbours(Cell(x: 3, y: 8, state: .dead))
        
        XCTAssertFalse(result)
    }
}
