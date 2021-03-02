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
    var cancellables: Set<AnyCancellable> = .init()
    @Published private var scores = 0
    
    static let correctCoefficient = 10
    static let incorrectMaxCoefficient = 2
    
    init() {
        let failedNoteWithScore = failedNotes
            .map { notes -> (note: Note, score: Int) in
                let difference: Int = abs(Int(notes.0.value) - Int(notes.1.value))
                let score = Self.incorrectMaxCoefficient / difference
                return (note: notes.correct, score: score)
            }
        
        let correctNoteWithScore = correctNotes
            .map { (note: $0, score: Self.correctCoefficient) }
            
        failedNoteWithScore.merge(with: correctNoteWithScore)
            .removeDuplicates {
                $0.note == $1.note
            }
            .map { $0.score }
            .assign(to: \.scores, on: self)
            .store(in: &cancellables)
    }
}

extension ScoreCounter: ScoreCounterInput {}

extension ScoreCounter: ScoreCounterOutput {
    var score: AnyPublisher<Int, Never> {
        $scores.scan(0, +).eraseToAnyPublisher()
    }
}
