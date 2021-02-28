//
//  NoteCorrectnessReceiver.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Combine
import Foundation

protocol NoteCorrectnessReceiver {
    var failedNotes: PassthroughSubject<(correct: Note, played: Note), Never> { get }
    var correctNotes: PassthroughSubject<Note, Never> { get }
}
