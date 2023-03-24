//
//  MenuView.swift
//  Reversi
//
//  Created by Yash Sangha on 14/03/2023.
//

import SwiftUI

struct MenuView: View {
    @State private var agent: PlayerType = .alphaZero
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Reversi")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .padding(20)
                    
                    Spacer()
                    VStack {
                        NavigationLink("Random", destination: BoardView().environmentObject(Game(from: GameSettings(player2: .random))))
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                        
                        NavigationLink("Minimax", destination: BoardView().environmentObject(Game(from: GameSettings(player2: .minimax))))
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                        
                        NavigationLink("AlphaZero", destination: BoardView().environmentObject(Game(from: GameSettings(player2: .alphaZero))))
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                        
                        NavigationLink("AlphaZero vs Minimax", destination: BoardView().environmentObject(Game(from: GameSettings(player1: .alphaZero, player2: .minimax))))
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                        
                        NavigationLink("AlphaZero vs Random", destination: BoardView().environmentObject(Game(from: GameSettings(player1: .alphaZero, player2: .random))))
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                    }
                    .tint(.black)
                    
                    Spacer()
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
