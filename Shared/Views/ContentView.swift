//
//  ContentView.swift
//  Shared
//
//  Created by Simon Lebedev on 20.02.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        VStack {
            Text("Score:")
            Text(verbatim: game.score)
            Divider()
            HStack {
            ForEach(game.notes, id: \.self) {
                Text(verbatim: $0.name).foregroundColor($0.color)
            }
            }
            HStack {
                Text("Repeat after me")
                    .padding()
                Button("Play") {
                    game.onPlayTap()
                }
            }
            PianoView(playedNotes: $game.playedNotes)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Game())
    }
}
