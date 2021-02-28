//
//  Game.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Combine
import SwiftUI
import Foundation

class Game: ObservableObject {
    @Published var score: String = ""
    @Published var notes: NSAttributedString = .init()
    
    private let midiPlayer: MidiPlayerProtocol
    private let randomMidiGenerator: MidiGeneratorProtocol
    private var midiReceiver: MidiReceiverProtocol
    private let midiChecker: MidiCheckerProtocol
    private let scoreCounter = ScoreCounter()
    private let noteNameProvider = NoteNameProducer()
    private let noteCorrectnessReceiver: NoteCorrectnessReceiver
    private var cancelables: Set<AnyCancellable> = .init()
    
    init() {
        midiPlayer = MidiPlayer(instrument: PianoInstrument())
        randomMidiGenerator = RandomMidiGenerator()
        midiReceiver = MidiReceiver()
        noteCorrectnessReceiver = AnyNoteCorrectnessReceiver(scoreCounter, noteNameProvider)
        midiChecker = MidiChecker(correctnessReceiver: noteCorrectnessReceiver)
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
        scoreCounter
            .score
            .map { "\($0)" }.assign(to: \.score, on: self)
            .store(in: &cancelables)
        
        noteNameProvider
            .playedNames
            .map { $0.reduce(NSMutableAttributedString()) { $0.append($1); return $0 } } // TODO: Refactor
            .assign(to: \.notes, on: self)
            .store(in: &cancelables)
    }
    
    func onPlayTap() {
        let notes = randomMidiGenerator.generate()
        midiPlayer.play(notes: notes)
        midiChecker.check(referenceNotes: notes)
    }
}
