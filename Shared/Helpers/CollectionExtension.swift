//
//  CollectionExtension.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 22.02.2021.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
