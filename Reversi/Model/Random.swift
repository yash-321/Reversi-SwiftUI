//
//  Random.swift
//  Reversi
//
//  Created by Yash Sangha on 23/03/2023.
//

import Foundation

class Random: MoveChooser {
    func chooseMove(boardState: BoardState, settings: GameSettings) -> Move? {
        let moves = boardState.getLegalMoves()
        return moves.randomElement()
    }
    
}
