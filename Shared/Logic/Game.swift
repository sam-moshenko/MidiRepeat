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
    @Published var notes: [NoteNameViewModel] = .init()
    
    private let midiPlayer: MidiPlayerProtocol
    private let randomMidiGenerator: MidiGeneratorProtocol
    private var midiReceiver: MidiReceiverProtocol
    private let midiChecker: MidiCheckerProtocol
    private let scoreCounter = ScoreCounter()
    private let noteNameProvider = NoteNameProducer()
    private let noteCorrectnessReceiver: NoteCorrectnessReceiver
    private var noteCorrectnessReceiverCancellables: Set<AnyCancellable> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        midiPlayer = MidiPlayer(instrument: PianoInstrument())
        randomMidiGenerator = RandomMidiGenerator()
        midiReceiver = MidiReceiver()
        noteCorrectnessReceiver = AnyNoteCorrectnessReceiver(scoreCounter, noteNameProvider)
        midiChecker = MidiChecker(correctnessReceiver: noteCorrectnessReceiver)
        midiReceiver.packetBlock = { [unowned self] (packet) in
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
    
    func onPlayTap() {
        let notes = randomMidiGenerator.generate()
        midiPlayer.play(notes: notes)
        midiChecker.check(referenceNotes: notes)
        assignNoteCorrectness()
    }
    
    private func assignNoteCorrectness() {
        noteCorrectnessReceiverCancellables.forEach { $0.cancel() }
        
        scoreCounter
            .score
            .map { "\($0)" }
            .assign(to: \.score, on: self)
            .store(in: &noteCorrectnessReceiverCancellables)
        
        noteNameProvider
            .playedNames
            .assign(to: \.notes, on: self)
            .store(in: &noteCorrectnessReceiverCancellables)
    }
}
