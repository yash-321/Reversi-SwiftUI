//
//  MoveChooser.swift
//  Reversi
//
//  Created by Yash Sangha on 18/10/2022.
//

import Foundation

protocol MoveChooser{
    func chooseMove(boardState: BoardState, settings: GameSettings) -> Move?
}

