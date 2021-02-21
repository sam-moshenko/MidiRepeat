//
//  MidiChecker.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation

protocol MidiCheckerProtocol {
    func check(referenceNotes: [Note])
    func onTapNote(_ note: Note)
}

class MidiChecker: MidiCheckerProtocol {
    private var referenceNotes: [Note] = []
    private var notesPlayed: Int = 0
    
    func check(referenceNotes: [Note]) {
        notesPlayed = 0
        self.referenceNotes = referenceNotes
    }
    
    func onTapNote(_ note: Note) {
        let noteIndex = notesPlayed
        guard let correctNote = referenceNotes[safe: noteIndex] else { return }
        if correctNote == note {
            notesPlayed += 1
            print("Correct note \(note.key.rawValue)")
        } else {
            print("Incorrect note \(note.key.rawValue), correct is \(correctNote.key.rawValue)")
        }
    }
}
