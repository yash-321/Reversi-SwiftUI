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
        
        var alpha = Int.min
        var beta = Int.max
        var values = Array(repeating: 0, count: moves.count)
        for (index, move) in moves.enumerated() {
            let newBoardState = boardState.deepCopy()
            newBoardState.makeLegalMove(x: move.x, y: move.y)
            values[index] = minimax(boardState: newBoardState, depth: searchDepth-1, bMaximising: false, alpha: &alpha, beta: &beta)
        }
        dump(values)
        let highVal = values.max()
        let bestMoveIndex = values.firstIndex(of: highVal!)
        print(highVal!)
        return moves[bestMoveIndex!]
    }
    
    private static func minimax(boardState: BoardState, depth: Int, bMaximising: Bool, alpha: inout Int, beta: inout Int) -> Int {
        // leaf node
        if boardState.gameOver() || depth == 0 {
            return evaluateBoard(boardState: boardState)
        }
        
        // Maximising Player
        if bMaximising {
            let moves = boardState.getLegalMoves()
            if moves.isEmpty {
                let newBoardState = boardState.deepCopy()
                newBoardState.changePlayer()
                return minimax(boardState: newBoardState, depth: depth-1, bMaximising: false, alpha: &alpha, beta: &beta)
            }
            var best = Int.min
            for move in moves {
                let newBoardState = boardState.deepCopy()
                newBoardState.makeLegalMove(x: move.x, y: move.y)
                let value = minimax(boardState: newBoardState, depth: depth-1, bMaximising: false, alpha: &alpha, beta: &beta)
                best = max(best, value)
                alpha = max(alpha, best)
                if beta <= alpha {
                    break
                }
            }
            
            return best
            
        } else { // Minimising Player
            let moves = boardState.getLegalMoves()
            if moves.isEmpty {
                let newBoardState = boardState.deepCopy()
                newBoardState.changePlayer()
                return minimax(boardState: newBoardState, depth: depth-1, bMaximising: true, alpha: &alpha, beta: &beta)
            }
            var best = Int.max
            for move in moves {
                let newBoardState = boardState.deepCopy()
                newBoardState.makeLegalMove(x: move.x, y: move.y)
                let value = minimax(boardState: newBoardState, depth: depth-1, bMaximising: true, alpha: &alpha, beta: &beta)
                best = min(best, value)
                beta = min(beta, best)
                if beta <= alpha {
                    break
                }
            }
            
            return best
        }
    }
    
    public static func evaluateBoard(boardState: BoardState) -> Int {
        // evaluation board weight array
        let a = [120, -20, 20, 5, 5, 20, -20, 120]
        let b = [-20, -40, -5, -5, -5, -5, -40, -20]
        let c = [20, -5, 15, 3, 3, 15, -5, 20]
        let d = [5, -5, 3, 3, 3, 3, -5, 5]
        let values: [[Int]] = [[Int]](repeating: [Int](repeating: 1, count: 8), count: 8)
        var black = 0
        var white = 0

        for i in 0..<values.count {
            for j in 0..<values[0].count {
                if boardState.getContents(x: i, y: j) == .Black {
                    black += values[i][j]
                } else if boardState.getContents(x: i, y: j) == .White {
                    white += values[i][j]
                }
            }
        }
        
        return white - black
    }
}

