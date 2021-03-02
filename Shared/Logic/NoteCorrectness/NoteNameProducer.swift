//
//  NoteNameProducer.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import SwiftUI
import Foundation

protocol NoteNameProducerInput: NoteCorrectnessReceiver {}

protocol NoteNameProducerOutput {
    var playedNames: AnyPublisher<[NoteNameViewModel], Never> { get }
}

class NoteNameProducer: NoteNameProducerInput {
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> = .init()
    var correctNotes: PassthroughSubject<Note, Never> = .init()
    @Published private var playedName: NoteNameViewModel? = nil
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        let failedNoteNames = failedNotes
            .map { $0.correct.key.string }
            .map { NoteNameViewModel(name: $0, correctness: .incorrect) }
    
        let correctNoteNames = correctNotes
            .map { $0.key.string }
            .map { NoteNameViewModel(name: $0, correctness: .correct) }
        
        failedNoteNames.merge(with: correctNoteNames)
            .removeDuplicates {
                $0.name == $1.name
            }
            .compactMap { $0 }
            .assign(to: \.playedName, on: self)
            .store(in: &cancellables)
    }
}

extension NoteNameProducer: NoteNameProducerOutput {
    var playedNames: AnyPublisher<[NoteNameViewModel], Never> {
        $playedName
            .compactMap { $0 }
            .scan([NoteNameViewModel]()) { $0.appending($1) }
            .eraseToAnyPublisher()
    }
}
