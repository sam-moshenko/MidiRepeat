//
//  ContentView.swift
//  Shared
//
//  Created by Simon Lebedev on 20.02.2021.
//

import SwiftUI

struct ContentView: View {
    let midiSynth: MidiSynthesizer
    
    var body: some View {
        HStack {
        Text("Repeat after me")
            .padding()
            Button("Play") {
                midiSynth.play()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(midiSynth: RandomMidiSynthesizer())
    }
}
