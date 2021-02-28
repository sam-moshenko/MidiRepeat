//
//  ScoreCounterTests.swift
//  MidiRepeatTests
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import XCTest
@testable import MidiRepeat

class ScoreCounterTests: XCTestCase {
    let sut = ScoreCounter()
    var sutInput: ScoreCounterInput { sut }
    var sutOutput: ScoreCounterOutput { sut }
    var cancelables = Set<AnyCancellable>()
    
    func testFailedNotes() {
        var expectedScores = [0, 2, 3, 3]
        let valueExpectation = expectation(description: "Value output")
        valueExpectation.expectedFulfillmentCount = expectedScores.count
        sutOutput.score.sink { value in
            XCTAssertEqual(expectedScores[0], value)
            expectedScores.remove(at: 0)
            valueExpectation.fulfill()
        }.store(in: &cancelables)
        sutInput.failedNotes.send((.init(value: 9), .init(value: 10)))
        sutInput.failedNotes.send((.init(value: 12), .init(value: 10)))
        sutInput.failedNotes.send((.init(value: 13), .init(value: 10)))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCorrectNotes() {
        var expectedScores = [0, 10, 20]
        let valueExpectation = expectation(description: "Value output")
        valueExpectation.expectedFulfillmentCount = expectedScores.count
        sutOutput.score.sink { value in
            XCTAssertEqual(expectedScores[0], value)
            expectedScores.remove(at: 0)
            valueExpectation.fulfill()
        }.store(in: &cancelables)
        sutInput.correctNotes.send(())
        sutInput.correctNotes.send(())
        waitForExpectations(timeout: 1, handler: nil)
    }
}
