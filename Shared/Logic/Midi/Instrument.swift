//
//  AudioEngine.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 22.02.2021.
//

import Foundation
import AVFoundation

protocol Instrument {
    func startNote(_ note: Note)
    func stopNote(_ note: Note)
}

extension Instrument {
    func playShortNote(_ note: Note) {
        DispatchQueue.global(qos: .background).async {
            startNote(note)
            sleep(1)
            stopNote(note)
        }
    }
}

class PianoInstrument: Instrument {
    private let engine = AVAudioEngine()
    private(set) var sampler = AVAudioUnitSampler()
    private let reverb = AVAudioUnitReverb()
    private let delay = AVAudioUnitDelay()
    
    private let url = Bundle.main.url(
        forResource: "piano",
        withExtension: "sf2"
    )!
    
    init() {
        engine.attach(sampler)
        engine.attach(reverb)
        
        engine.connect(sampler, to: reverb, format: nil)
        engine.connect(reverb, to: engine.mainMixerNode, format: nil)
        
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 30.0
        
        try! engine.start()
        
        let msb = UInt8(kAUSampler_DefaultMelodicBankMSB)
        let lsb = UInt8(kAUSampler_DefaultBankLSB)
        
        DispatchQueue.global(qos: .background).async { [unowned self] in
            try! sampler.loadSoundBankInstrument(at: url, program: 0, bankMSB: msb, bankLSB: lsb)
        }
    }
    
    func startNote(_ note: Note) {
        sampler.startNote(note.value, withVelocity: 70, onChannel: 0)
    }
    
    func stopNote(_ note: Note) {
        sampler.stopNote(note.value, onChannel: 0)
    }
}
