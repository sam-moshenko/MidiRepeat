//
//  NoteNameProducer.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import SwiftUI
import Foundation

protocol NoteNameProducerInput: NoteCorrectnessReceiver {}

protocol NoteNameProducerOutput {
    var playedNames: AnyPublisher<[NSAttributedString], Never> { get }
}

class NoteNameProducer: NoteNameProducerInput {
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> = .init()
    var correctNotes: PassthroughSubject<Note, Never> = .init()
    @Published private var playedName: NSAttributedString? = nil
    private var cancelables: Set<AnyCancellable> = .init()
    private static let correctAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: Color.green]
    private static let failedAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: Color.red]
    
    init() {
        failedNotes
            .map { $0.correct.key.string }
            .map { NSAttributedString(string: $0, attributes: Self.failedAttributes) }
            .assign(to: \.playedName, on: self)
            .store(in: &cancelables)
        
        correctNotes
            .map { $0.key.string }
            .map { NSAttributedString(string: $0, attributes: Self.correctAttributes) }
            .assign(to: \.playedName, on: self)
            .store(in: &cancelables)
    }
}

extension NoteNameProducer: NoteNameProducerOutput {
    var playedNames: AnyPublisher<[NSAttributedString], Never> {
        $playedName
            .compactMap { $0 }
            .scan([NSAttributedString]()) { $0.appending($1) }
            .eraseToAnyPublisher()
    }
}
