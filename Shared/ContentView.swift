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
            Text(verbatim: game.notes.string)
            HStack {
                Text("Repeat after me")
                    .padding()
                Button("Play") {
                    game.onPlayTap()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Game())
    }
}
