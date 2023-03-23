//
//  BoardView.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var game: Game

    var body: some View {
        ZStack{
            Color.green
              .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Text("Turn")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                    
                    game.turnImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: game.settings.squareSize,
                               height: game.settings.squareSize,
                               alignment: .center)
                    
                }
                .alert(item: $game.skipGo) { player in
                    Alert(title: Text("No legal moves"),
                          message: Text("There are no legal moves that \(player) can play"),
                          dismissButton: .default(Text("Skip Go")){
                        if player == "black" {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                game.aiTurn()
                            }
                        }
                    })
                }
                
                Spacer()
                VStack(spacing: 0) {
                    ForEach(0..<game.settings.rows, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<game.settings.columns, id: \.self) { col in
                                CellView(cell: game.boardState.getCell(x: row, y: col))
                            }
                        }
                    }
                }
                .alert(item: $game.gameWinner) { winner in
                    Alert(title: Text("\(winner) wins"),
                          message: Text(game.resultString),
                          dismissButton: .default(Text("Play Again")){
                        game.resetBoard()
                        withAnimation {
                            if winner == "Black" {
                                game.blackWins += 1
                            } else if winner == "White" {
                                game.whiteWins += 1
                            }
                        }
                    })
                }

                
                Spacer()
                HStack {
                    Text("\(game.blackWins)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: game.settings.squareSize, height: game.settings.squareSize)
                        .background(.black)
                    Text("\(game.whiteWins)")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: game.settings.squareSize, height: game.settings.squareSize)
                        .background(Color.white)
                }
            }
        }
        .onTapGesture {
            game.click(on: nil)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    private static var gameSettings = GameSettings(player2: .alphaZero)
    static var previews: some View {
        BoardView()
            .environmentObject(Game(from: gameSettings))
    }
}
