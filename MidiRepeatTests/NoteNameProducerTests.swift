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
    var cancelables: Set<AnyCancellable> = .init()
    
    func testNotes() {
        let expected: [NSAttributedString] = [
            .init(string: "C", attributes: [.foregroundColor: Color.green]),
            .init(string: "C#", attributes: [.foregroundColor: Color.red]),
            .init(string: "D", attributes: [.foregroundColor: Color.green])
        ]
        var expectedSeries: [[NSAttributedString]] = [expected[0..<1], expected[0..<2], expected[0..<3]].map { Array($0) }
        let namesExpectation = expectation(description: "Names expectation")
        namesExpectation.expectedFulfillmentCount = expectedSeries.count
        sutOutput.playedNames.sink {
            print($0)
            XCTAssertEqual($0, expectedSeries.first)
            expectedSeries.removeFirst()
            namesExpectation.fulfill()
        }.store(in: &cancelables)
        sutInput.correctNotes.send(.init(value: 0))
        sutInput.failedNotes.send((.init(value: 1), .init(value: 0)))
        sutInput.correctNotes.send(.init(value: 2))
        waitForExpectations(timeout: 1, handler: nil)
    }
}
