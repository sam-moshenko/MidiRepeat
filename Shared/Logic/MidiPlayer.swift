//
//  RandomMidiSynthesizer.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation

protocol MidiPlayerProtocol {
    func play(notes: [Note])
    func startNote(_ note: Note)
    func stopNote(_ note: Note)
}

class MidiPlayer: MidiPlayerProtocol {
    private let playTime = 1
    
    private let instrument: Instrument
    
    init(instrument: Instrument) {
        self.instrument = instrument
    }
    
    func play(notes: [Note]) {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            notes.forEach { play(note: $0) }
        }
    }
    
    func startNote(_ note: Note) {
        instrument.startNote(note)
    }
    
    func stopNote(_ note: Note) {
        instrument.stopNote(note)
    }
    
    private func play(note: Note) {
        startNote(note)
        sleep(UInt32(playTime))
        stopNote(note)
    }
}
