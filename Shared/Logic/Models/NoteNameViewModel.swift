//
//  NoteNameViewModel.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 02.03.2021.
//

import SwiftUI

struct NoteNameViewModel: Hashable {
    let name: String
    let correctness: Correctness
    
    enum Correctness {
        case correct, incorrect
    }
    
    var color: Color {
        switch correctness {
        case .correct:
            return .green
        case .incorrect:
            return .red
        }
    }
}
