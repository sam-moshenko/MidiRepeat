//
//  RandomMidiSynthesizer.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation
import R9MIDISequencer

protocol MidiSynthesizer {
    func play()
}

class RandomMidiSynthesizer: MidiSynthesizer {
    let highestNote = 62
    let lowestNote = 36
    let playTime = 1
    let noteCount = 5
    
    let url = Bundle.main.url(
        forResource: "piano",
        withExtension: "sf2"
    )!
    let sampler = Sampler(channelNumber: 1)
    
    init() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            sampler.loadMelodicBankInstrument(at: url)
        }
    }
    
    func play() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            (0..<noteCount).forEach { _ in playRandomNote() }
        }
    }
    
    private func playRandomNote() {
        let note = (Int(arc4random()) % (highestNote - lowestNote)) + lowestNote
        playNote(note: UInt8(note))
    }
    
    private func playNote(note: UInt8) {
        sampler.startNote(note)
        sleep(UInt32(playTime))
        sampler.stopNote(note)
    }
}
