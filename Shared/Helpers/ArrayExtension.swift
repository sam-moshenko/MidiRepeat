//
//  ArrayExtension.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 28.02.2021.
//

import Foundation

extension Array {
    func appending(_ obj: Element) -> [Element] {
        var copy = self
        copy.append(obj)
        return copy
    }
    
    func appending(contentsOf array: [Element]) -> [Element] {
        var copy = self
        copy.append(contentsOf: array)
        return copy
    }
}
