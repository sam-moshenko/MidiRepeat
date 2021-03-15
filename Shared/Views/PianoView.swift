//
//  PianoView.swift
//  MidiRepeat
//
//  Created by Simon Lebedev on 06.03.2021.
//

import SwiftUI

struct PianoView: View {
    var notes: [Note] = (0...48)
        .map { Note(value: $0) }
    var whiteNotes: [Note] {
        notes.filter { $0.isWhite }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                let whiteSpacing: CGFloat = 2
                let whiteWidth = geometry.size.width / CGFloat(whiteNotes.count) - whiteSpacing
                let blackWidth = whiteWidth / 2
                HStack(spacing: whiteSpacing) {
                    ForEach(whiteNotes, id: \.self) { note -> AnyView in
                        return AnyView(
                            Rectangle()
                                .foregroundColor(Color(white: 0.85))
                                .frame(width: whiteWidth - whiteSpacing)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    print(note.key)
                                }
                        )
                    }
                }
                .frame(height: geometry.size.height)
                .fixedSize()
                HStack(spacing: 0) {
                    var spacing: CGFloat = 0
                    ForEach(notes, id: \.self) { (note) -> AnyView? in
                        if note.isWhite {
                            spacing += whiteWidth
                            return nil
                        } else {
                            let _spacing = spacing
                            spacing = -blackWidth / 2
                            return AnyView(
                                HStack(spacing: 0) {
                                    Spacer(minLength: _spacing - blackWidth / 2)
                                    Rectangle()
                                        .foregroundColor(Color(white: 0.1))
                                        .frame(width: blackWidth)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            print(note.key)
                                        }
                                }
                            )
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.7, alignment: .top)
                .fixedSize()
            }
        }
    }
}

struct PianoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PianoView()
        }
    }
}
