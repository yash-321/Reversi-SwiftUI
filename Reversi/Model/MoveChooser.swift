//
//  MoveChooser.swift
//  Reversi
//
//  Created by Yash Sangha on 18/10/2022.
//

import Foundation

class MoveChooser{
    public static func chooseMove(boardState: BoardState, settings: GameSettings) -> Move? {
        let searchDepth = settings.searchDepth
        
        let moves = boardState.getLegalMoves()
        if moves.isEmpty {
            return nil
        }
        return moves[0]
    }
}

