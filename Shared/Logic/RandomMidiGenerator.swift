//
//  RandomMidiGenerator.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 21.02.2021.
//

import Foundation

typealias Note = UInt8

protocol MidiGeneratorProtocol {
    func generate() -> [Note]
}

class RandomMidiGenerator: MidiGeneratorProtocol {
    let highestNote = 62
    let lowestNote = 49
    let noteCount = 4
    
    func generate() -> [Note] {
        (0..<noteCount)
            .map{ _ in (Int(arc4random()) % (highestNote - lowestNote)) + lowestNote }
            .map { UInt8($0) }
    }
}
