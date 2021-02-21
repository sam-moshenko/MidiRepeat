//
//  Game.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation

class Game {
    private let midiPlayer: MidiPlayerProtocol
    private let randomMidiGenerator: MidiGeneratorProtocol
    private var midiReceiver: MidiReceiverProtocol
    private let midiChecker: MidiCheckerProtocol
    
    init() {
        midiPlayer = MidiPlayer()
        randomMidiGenerator = RandomMidiGenerator()
        midiReceiver = MidiReceiver()
        midiChecker = MidiChecker()
        midiReceiver.packetBlock = { [unowned self] (packet) in
            DispatchQueue.global(qos: .background).async { [unowned self] in
                switch packet.command {
                case .noteUp:
                    midiPlayer.stopNote(packet.note)
                case .noteDown:
                    midiChecker.onTapNote(packet.note)
                    midiPlayer.startNote(packet.note)
                case .none: break
                }
            }
        }
    }
    
    func onPlayTap() {
        let notes = randomMidiGenerator.generate()
        midiPlayer.play(notes: notes)
        midiChecker.check(referenceNotes: notes)
    }
}
