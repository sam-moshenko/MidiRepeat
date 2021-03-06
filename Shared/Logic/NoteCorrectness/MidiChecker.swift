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
    private let correctnessReceiver: NoteCorrectnessReceiver
    
    init(correctnessReceiver: NoteCorrectnessReceiver) {
        self.correctnessReceiver = correctnessReceiver
    }
    
    func check(referenceNotes: [Note]) {
        notesPlayed = 0
        self.referenceNotes = referenceNotes
    }
    
    func onTapNote(_ note: Note) {
        let noteIndex = notesPlayed
        guard let correctNote = referenceNotes[safe: noteIndex] else { return }
        if correctNote == note {
            notesPlayed += 1
            correctnessReceiver.correctNotes.send(note)
        } else {
            correctnessReceiver.failedNotes.send((correct: correctNote, played: note))
            print("Incorrect note \(note.key.string), correct is \(correctNote.key.string)")
        }
    }
}
