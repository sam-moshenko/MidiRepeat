//
//  MidiCheckerTests.swift
//  MidiRepeatTests
//
//  Created by Simon Lebedev on 23.03.2021.
//

import Foundation
import XCTest
import Combine
@testable import MidiRepeat

class MidiCheckerTests: XCTestCase {
    private let correctnessReceiver = MockCorrectnessReceiver()
    lazy var sut: MidiCheckerProtocol = MidiChecker(correctnessReceiver: correctnessReceiver)
    
    func testRepeatativeNotes() {
        sut.check(referenceNotes: [.init(value: 0), .init(value: 0), .init(value: 0)])
        XCTAssertEqual(correctnessReceiver.correctness, [])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [true])
        sut.onTapNote(.init(value: 2))
        XCTAssertEqual(correctnessReceiver.correctness, [true, false])
        sut.onTapNote(.init(value: 1))
        XCTAssertEqual(correctnessReceiver.correctness, [true, false, false])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [true, false, false, true])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [true, false, false, true, true])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [true, false, false, true, true])
    }
    
    func testDifferentNotes() {
        sut.check(referenceNotes: [.init(value: 0), .init(value: 5), .init(value: 10)])
        XCTAssertEqual(correctnessReceiver.correctness, [])
        sut.onTapNote(.init(value: 1))
        XCTAssertEqual(correctnessReceiver.correctness, [false])
        sut.onTapNote(.init(value: 2))
        XCTAssertEqual(correctnessReceiver.correctness, [false, false])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [false, false, true])
        sut.onTapNote(.init(value: 5))
        XCTAssertEqual(correctnessReceiver.correctness, [false, false, true, true])
        sut.onTapNote(.init(value: 10))
        XCTAssertEqual(correctnessReceiver.correctness, [false, false, true, true, true])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [false, false, true, true, true])
    }
    
    func testReset() {
        sut.check(referenceNotes: [.init(value: 0)])
        XCTAssertEqual(correctnessReceiver.correctness, [])
        sut.onTapNote(.init(value: 0))
        XCTAssertEqual(correctnessReceiver.correctness, [true])
        sut.check(referenceNotes: [.init(value: 0)])
        XCTAssertEqual(correctnessReceiver.correctness, [])
    }
}

fileprivate class MockCorrectnessReceiver: NoteCorrectnessReceiver {
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> = .init()
    var correctNotes: PassthroughSubject<Note, Never> = .init()
    var reset: PassthroughSubject<Void, Never> = .init()
    var correctness: [Bool] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        [
            failedNotes.sink { [unowned self] _ in
                correctness.append(false)
            },
            correctNotes.sink { [unowned self] _ in
                correctness.append(true)
            },
            reset.sink { [unowned self] in
                correctness = []
            }
        ].forEach { $0.store(in: &cancellables) }
    }
}
