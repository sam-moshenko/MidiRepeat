//
//  NoteNameProducerTests.swift
//  MidiRepeatTests
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import Foundation
import SwiftUI
import XCTest
@testable import MidiRepeat

class NoteNameProducerTests: XCTestCase {
    let sut = NoteNameProducer()
    var sutInput: NoteNameProducerInput { sut }
    var sutOutput: NoteNameProducerOutput { sut }
    var cancellables: Set<AnyCancellable> = .init()
    
    func testNotes() {
        let expected: [NoteNameViewModel] = [
            .init(name: "C", correctness: .correct),
            .init(name: "C#", correctness: .incorrect),
            .init(name: "D", correctness: .correct)
        ]
        var expectedSeries: [[NoteNameViewModel]] = expected.enumerated().map {
            expected[0...($0.offset)]
        }.map { Array($0) }
        
        let namesExpectation = expectation(description: "Names expectation")
        namesExpectation.expectedFulfillmentCount = expectedSeries.count
    
        sutOutput.playedNames.sink {
            print($0)
            XCTAssertEqual($0, expectedSeries.first)
            expectedSeries.removeFirst()
            namesExpectation.fulfill()
        }.store(in: &cancellables)
        
        sendNotes()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private func sendNotes() {
        sutInput.correctNotes.send(.init(value: 0))
        sutInput.failedNotes.send((correct: .init(value: 1), played: .init(value: 0)))
        sutInput.failedNotes.send((correct: .init(value: 1), played: .init(value: 2)))
        sutInput.correctNotes.send(.init(value: 1))
        sutInput.correctNotes.send(.init(value: 2))
    }
}
