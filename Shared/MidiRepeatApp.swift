//
//  MidiRepeatApp.swift
//  Shared
//
//  Created by Simon Lebedev on 20.02.2021.
//

import SwiftUI

@main
struct MidiRepeatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Game())
        }
    }
}
