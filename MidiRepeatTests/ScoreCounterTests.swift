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
    var cancellables = Set<AnyCancellable>()
    
    func testNotes() {
        var expectedScores = getExpectedScores(expectedCorrectness: [.correct, .incorrect, .incorrect])
        let valueExpectation = expectation(description: "Value output")
        valueExpectation.expectedFulfillmentCount = expectedScores.count
        sutOutput.score.sink { value in
            XCTAssertEqual(expectedScores[0], value)
            expectedScores.remove(at: 0)
            valueExpectation.fulfill()
        }.store(in: &cancellables)
        sutInput.correctNotes.send(.init(value: 0))
        sutInput.failedNotes.send((correct: .init(value: 1), played: .init(value: 2)))
        sutInput.correctNotes.send(.init(value: 1))
        sutInput.failedNotes.send((correct: .init(value: 2), played: .init(value: 3)))
        sutInput.failedNotes.send((correct: .init(value: 2), played: .init(value: 4)))
        sutInput.correctNotes.send(.init(value: 2))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private func getExpectedScores(expectedCorrectness: [NoteNameViewModel.Correctness]) -> [Int] {
        expectedCorrectness.enumerated().reduce([0]) {
            let additive: Int
            switch $1.element {
            case .correct: additive = ScoreCounter.correctCoefficient
            case .incorrect: additive = ScoreCounter.incorrectMaxCoefficient
            }
            let previous = $0[$1.offset]
            return $0.appending(previous + additive)
        }
    }
}
