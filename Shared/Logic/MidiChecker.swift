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
        if referenceNotes[safe: noteIndex] == note {
            notesPlayed += 1
            print("Correct note")
        } else {
            print("Incorrect note")
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
