//
//  CellView.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import SwiftUI

struct CellView: View {
    @EnvironmentObject var game: Game
    let cell: Cell
    
    var body: some View {
        cell.image
            .resizable()
            .scaledToFill()
            .frame(width: game.settings.squareSize,
                    height: game.settings.squareSize,
                    alignment: .center)
            .border(.black, width: 1)
            .onTapGesture {
                game.click(on: cell)
            }
        
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: Cell(row: 0, column: 0, piece: .Black))
            .environmentObject(Game(from: GameSettings()))
    }
}
