//
//  GameViewControllerTests.swift
//  GameOfLifeTests
//
//  Created by Ananth Bhamidipati on 10/07/2022.
//

import XCTest

final class GameViewControllerTests: XCTestCase {

    // MARK: Subject under test
    
    var sut: GameViewController!
    private var viewModel: GameViewModelSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
      super.setUp()
        
      setupGameViewController()
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
      
      super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupGameViewController() {
        viewModel = GameViewModelSpy()
        sut = GameViewController(viewModel: viewModel)
        sut.loadView()
    }
        
    // MARK: View Loaded
    
    func test_givenScene_whenViewIsLoaded_thenloadViewIsCalled() {
        XCTAssertTrue(sut.isViewLoaded)
    }
    
    func test_givenScene_whenViewDidLoad_thenSetBoardToInitialIsCalled() {
        sut.viewDidLoad()
        XCTAssertTrue(viewModel.setBoardToInitialCalled)
    }
    
    // MARK: View Not Loaded
    
    func testInitWithCoder() {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: sut!, requiringSecureCoding: false)
        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)
        sut = GameViewController(coder: coder)
        XCTAssertNotNil(sut)
    }
    
    // MARK: UI Interaction
    
    func test_givenScene_whenAStartButtonIsTapped_thenViewModelIsCalled() {
        tapStartButton()
        XCTAssertTrue(viewModel.startGameCalled)
    }
    
    func test_givenScene_whenResetButtonIsTapped_thenViewModelIsCalled() {
        tapResetButton()
        XCTAssertTrue(viewModel.setBoardToInitialCalled)
    }
    
    func test_givenScene_whenAStartButtonIsTappedAndGameOngoing_thenViewModelIsNotCalled() {
        viewModel.toggleGameOnGoingStatus()
        tapStartButton()
        XCTAssertFalse(viewModel.startGameCalled)
    }
    
    func test_givenScene_whenAResetButtonIsTappedAndGameOngoing_thenViewModelIsNotCalled() {
        viewModel.toggleGameOnGoingStatus()
        tapResetButton()
        XCTAssertFalse(viewModel.setBoardToInitialCalled)
    }
    
    // MARK: Output UI
    
    func test_givenScene_whenUpdateUIIsCalledForNewGeneration_thenUIUpdates() {
        let cells: [Cell] = [Cell(x: 0, y: 0, state: .live), Cell(x: 0, y: 0, state: .dead)]
        sut.updateUI(cells: cells, currentGeneration: 1)
        
        let labelText = getInfoLabelText()
        // check if boardView snapshots match the cells
        
        XCTAssertEqual(labelText, "Generation 1")
    }
    
    func test_givenScene_whenUpdateUIIsCalledForReset_thenUIUpdates() {
        let cells: [Cell] = [Cell(x: 0, y: 0, state: .live), Cell(x: 0, y: 0, state: .dead)]
        sut.updateUI(cells: cells, currentGeneration: 0)
        
        let labelText = getInfoLabelText()
        // check if boardView snapshots match the cells
        
        XCTAssertEqual(labelText, "Tap on Start button below")
    }

}

private extension GameViewControllerTests {
    func tapStartButton() {
        let mirror = Mirror.init(reflecting: sut.view as Any)
        for child in mirror.children {
            if let view = child.value as? UIView {
                for subview in view.subviews {
                    if let button = subview as? UIButton, button.title(for: .normal) == "START" {
                        button.sendActions(for: .touchUpInside)
                    }
                }
            }
        }
    }
    
    func tapResetButton() {
        let mirror = Mirror.init(reflecting: sut.view as Any)
        for child in mirror.children {
            if let view = child.value as? UIView {
                for subview in view.subviews {
                    if let button = subview as? UIButton, button.title(for: .normal) == "RESET" {
                        button.sendActions(for: .touchUpInside)
                    }
                }
            }
        }
    }
    
    func getInfoLabelText() -> String {
        let mirror = Mirror.init(reflecting: sut.view as Any)
        for child in mirror.children {
            if let view = child.value as? UIView {
                for subview in view.subviews {
                    if let label = subview as? UILabel, label.accessibilityIdentifier == "infoLabel" {
                        return label.text ?? ""
                    }
                }
            }
        }
        return "";
    }
}

private final class GameViewModelSpy: GameViewModel {
    var setBoardToInitialCalled = false
    var startGameCalled = false
    var gameOngoingStatus = false
    
    func toggleGameOnGoingStatus() {
        gameOngoingStatus = !gameOngoingStatus
    }
    
    // MARK: Delegate methods
    
    func setBoardToInitial() {
        setBoardToInitialCalled = true
    }
    
    func startGame(for generations: Int) {
        startGameCalled = true
    }
    
    var gameOngoing: Bool {
        return gameOngoingStatus
    }
}
