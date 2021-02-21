//
//  RandomMidiSynthesizer.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation
import R9MIDISequencer

protocol MidiPlayerProtocol {
    func play(notes: [Note])
    func startNote(_ note: Note)
    func stopNote(_ note: Note)
}

class MidiPlayer: MidiPlayerProtocol {
    private let playTime = 1
    
    private let url = Bundle.main.url(
        forResource: "piano",
        withExtension: "sf2"
    )!
    private let sampler = Sampler(channelNumber: 1)
    
    init() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            sampler.loadMelodicBankInstrument(at: url)
        }
    }
    
    func play(notes: [Note]) {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            notes.forEach { play(note: $0) }
        }
    }
    
    func startNote(_ note: Note) {
        sampler.startNote(note.value)
    }
    
    func stopNote(_ note: Note) {
        sampler.stopNote(note.value)
    }
    
    private func play(note: Note) {
        startNote(note)
        sleep(UInt32(playTime))
        stopNote(note)
    }
}
