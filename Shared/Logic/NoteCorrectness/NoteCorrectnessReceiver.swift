//
//  NoteCorrectnessReceiver.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import Foundation

protocol NoteCorrectnessReceiver {
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> { get }
    var correctNotes: PassthroughSubject<Note, Never> { get }
    var reset: PassthroughSubject<Void, Never> { get }
}

class AnyNoteCorrectnessReceiver: NoteCorrectnessReceiver {
    var reset: PassthroughSubject<Void, Never> = .init()
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> = .init()
    var correctNotes: PassthroughSubject<Note, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    private let receivers: [NoteCorrectnessReceiver]
    
    init(_ receivers: NoteCorrectnessReceiver...) {
        self.receivers = receivers
        
        receivers.forEach { [unowned self] receiver in
            failedNotes.sink {
                receiver.failedNotes.send($0)
            }.store(in: &cancellables)
            correctNotes.sink {
                receiver.correctNotes.send($0)
            }.store(in: &cancellables)
            reset.sink {
                receiver.reset.send($0)
            }.store(in: &cancellables)
        }
    }
}
