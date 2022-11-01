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
        }
    
    var turnImage: Image {
        return turn == .Black ? Image("black circle") : Image("white circle")
    }
    
    func click(on cell: Cell) {
        // Check we didn't click on a piece and its users turn
        if cell.piece == nil && turn == .Black {
            if boardState.checkLegalMove(x: cell.row, y: cell.column) {
                boardState.makeLegalMove(x: cell.row, y: cell.column)
                
                if boardState.gameOver() {
                    result()
                    return
                }
                
                let moves = boardState.getLegalMoves()
                if moves.isEmpty {
                    skipGo = "white"
                    boardState.changePlayer()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.aiTurn()
                }
            }
        }

        self.objectWillChange.send()
    }
    
    public func aiTurn() {
        if turn == .White {
            let move = MoveChooser.chooseMove(boardState: boardState, settings: settings)
            if move != nil {
                boardState.makeLegalMove(x: move!.x, y: move!.y)
            }
            
            if boardState.gameOver() {
                result()
                return
            }
            
            let moves = boardState.getLegalMoves()
            if moves.isEmpty {
                skipGo = "black"
                boardState.changePlayer()
            }
        }
        
        self.objectWillChange.send()
    }
    
    private func result() {
        let result = boardState.result()
        if result[.Black]! > result[.White]! {
            resultString = "\nBlack: " + String(result[.Black]!) + "\n\nWhite: " + String(result[.White]!)
            gameWinner = "Black"
        } else if result[.Black]! < result[.White]! {
            resultString = "\nBlack: " + String(result[.Black]!) + "\n\nWhite: " + String(result[.White]!)
            gameWinner = "White"
        } else {
            resultString = "\nBlack: " + String(result[.Black]!) + "\n\nWhite: " + String(result[.White]!)
            gameWinner = "Draw"
        }
        self.objectWillChange.send()
    }

    
    public func resetBoard() {
        boardState = BoardState(settings: settings, turn: (!startedPrev)!)
        startedPrev = (!startedPrev)!
        
        if turn == .White {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.aiTurn()
            }
        }
    }
}
