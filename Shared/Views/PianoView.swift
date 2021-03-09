//
//  PianoView.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 06.03.2021.
//

import SwiftUI

struct PianoView: View {
    var notes: [Note]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(Array(notes.enumerated()), id: \.element) { (offset, note) -> AnyView in
                    let width = geometry.size.width / CGFloat(notes.count)
                    if note.isWhite {
                        return AnyView(
                            Rectangle()
                                .foregroundColor(Color(white: 0.85))
                                .frame(width: width)
                        )
                    } else {
                        return AnyView(
                            Rectangle()
                                .foregroundColor(Color(white: 0.1))
                                .frame(width: width)
                                .onTapGesture {
                                    print("hi")
                                }
                        )
                    }
                }
            }.frame(width: geometry.size.width)
        }
    }
}

struct PianoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PianoView(notes: Note.Key.allCases[0...1].map { Note(key: $0, octave: 0) })
    
        }
    }
}
