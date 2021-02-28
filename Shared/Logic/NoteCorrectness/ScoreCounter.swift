//
//  ScoreCounter.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import Foundation

protocol ScoreCounterInput: NoteCorrectnessReceiver {}

protocol ScoreCounterOutput {
    var score: AnyPublisher<Int, Never> { get }
}

class ScoreCounter {
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> = .init()
    var correctNotes: PassthroughSubject<Note, Never> = .init()
    var cancelables: Set<AnyCancellable> = .init()
    @Published private var scores = 0
    
    init() {
        failedNotes
            .map { notes in
                let difference: Int = abs(Int(notes.0.value) - Int(notes.1.value))
                let score = 2 / difference
                return score
            }
            .assign(to: \.scores, on: self)
            .store(in: &cancelables)
        
        correctNotes
            .map { _ in 10 }
            .assign(to: \.scores, on: self)
            .store(in: &cancelables)
    }
}

extension ScoreCounter: ScoreCounterInput {}

extension ScoreCounter: ScoreCounterOutput {
    var score: AnyPublisher<Int, Never> {
        $scores.scan(0, +).eraseToAnyPublisher()
    }
}
