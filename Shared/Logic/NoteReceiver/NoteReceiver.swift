//
//  NoteReceiver.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 16.03.2021.
//

import Combine

protocol NoteReceiver {
    var notes: PassthroughSubject<Set<Note>, Never> { get }
}

class AnyNoteReceiver: NoteReceiver {
    var notes: PassthroughSubject<Set<Note>, Never> = .init()
    var cancellables: Set<AnyCancellable> = []
    
    init(_ noteReceivers: NoteReceiver...) {
        noteReceivers.forEach { receiver in
            notes.sink { value in
                receiver.notes.send(value)
            }.store(in: &cancellables)
        }
    }
}
