//
//  ReversiApp.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import SwiftUI

@main
struct ReversiApp: App {
    var gameSettings = GameSettings()
    
    var body: some Scene {
        WindowGroup {
            BoardView()
                .environmentObject(Game(from: gameSettings))
        }
    }
}
