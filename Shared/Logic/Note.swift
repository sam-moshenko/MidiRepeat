//
//  Note.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 22.02.2021.
//

import Foundation

struct Note: Equatable {
    let value: UInt8
    var key: Key {
        Key(rawValue: value % Key.count) ?? .c
    }
    var octave: UInt8 {
        value / Key.count
    }
    
    enum Key: UInt8, CaseIterable {
        case c = 0, cSharp, d, dSharp, e, f, fSharp, g, gSharp, a, aSharp, b
        
        static var count: UInt8 {
            UInt8(Self.allCases.count)
        }
        
        var string: String {
            switch self {
            case .c: return "C"
            case .cSharp: return "C#"
            case .d: return "D"
            case .dSharp: return "D#"
            case .e: return "E"
            case .f: return "F"
            case .fSharp: return "F#"
            case .g: return "G"
            case .gSharp: return "G#"
            case .a: return "A"
            case .aSharp: return "A#"
            case .b: return "B"
            }
        }
    }
}
