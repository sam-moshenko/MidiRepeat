//
//  PlayingScoringNoteReceiver.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 16.03.2021.
//

import Combine

class PlayingScoringNoteReceiver: NoteReceiver {
    var notes: PassthroughSubject<Set<Note>, Never> = .init()
    var observer: PassthroughSubject<Note, Never> = .init()
    var cancellables: Set<AnyCancellable> = .init()
    
    init(checker: MidiCheckerProtocol, instrument: Instrument) {
        var lastNotes: Set<Note> = []
        notes.sink { notes in
            notes.subtracting(lastNotes).forEach { note in
                checker.onTapNote(note)
                instrument.startNote(note)
            }
            lastNotes.subtracting(notes).forEach { note in
                instrument.stopNote(note)
            }
            lastNotes = notes
        }.store(in: &cancellables)
    }
}
