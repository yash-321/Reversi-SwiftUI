//
//  Game.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import Foundation
import SwiftUI

class Game: ObservableObject {
    // Game settings
    @Published var settings: GameSettings
    
    /// The game board
    @Published var boardState: BoardState
    
    private var turn: Piece {
        return boardState.turn
    }
    private var startedPrev: Piece = .Black
    @Published var skipGo: String?
    
    @Published var gameWinner: String?
    var resultString: String = ""
    
    @Published var blackWins = 0
    @Published var whiteWins = 0

    init(from settings: GameSettings) {
        self.settings = settings
        self.boardState = BoardState(settings: settings, turn: .Black) // construct our board
        
        if settings.bMoveIndicator {
            let moves = boardState.getLegalMoves()
            for move in moves {
                boardState.setStatus(x: move.x, y: move.y, status: .Potential(turn))
            }
        }
    }
    
    var turnImage: Image {
        return turn == .Black ? Image("black circle") : Image("white circle")
    }
    
    func click(on cell: Cell) {
        // Check we didn't click on a piece and its users turn
        if cell.piece == nil {
            if boardState.checkLegalMove(x: cell.row, y: cell.column) {
                boardState.makeLegalMove(x: cell.row, y: cell.column)
                
                if boardState.gameOver() {
                    let result = boardState.result()
                    if result[.Black]! > result[.White]! {
                        resultString = "\nBlack: " + String(result[.Black]!) + "\n\nWhite: " + String(result[.White]!)
                        blackWins += 1
                        gameWinner = "Black"
                    } else if result[.Black]! < result[.White]! {
                        resultString = "\nBlack: " + String(result[.Black]!) + "\n\nWhite: " + String(result[.White]!)
                        whiteWins += 1
                        gameWinner = "White"
                    } else {
                        resultString = "\nBlack: " + String(result[.Black]!) + "\n\nWhite: " + String(result[.White]!)
                        gameWinner = "Draw"
                    }
                    return
                }
                
                var moves = boardState.getLegalMoves()
                if moves.isEmpty {
                    skipGo = turn == .Black ? "black" : "white"
                    boardState.changePlayer()
                    moves = boardState.getLegalMoves()
                }
            }
        }

        self.objectWillChange.send()
    }
    
    public func resetBoard() {
        boardState = BoardState(settings: settings, turn: (!startedPrev)!)
        startedPrev = (!startedPrev)!
        
        if settings.bMoveIndicator {
            let moves = boardState.getLegalMoves()
            for move in moves {
                boardState.setStatus(x: move.x, y: move.y, status: .Potential(turn))
            }
        }
    }
    
}
