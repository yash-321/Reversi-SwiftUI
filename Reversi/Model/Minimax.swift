//
//  Minimax.swift
//  Reversi
//
//  Created by Yash Sangha on 23/02/2023.
//

import Foundation

class Minimax: MoveChooser{
    public func chooseMove(boardState: BoardState, settings: GameSettings) -> Move? {
        let searchDepth = settings.searchDepth
        let moves = boardState.getLegalMoves()
        if moves.isEmpty {
            return nil
        }
        
        var values = Array(repeating: 0, count: moves.count)
        for (index, move) in moves.enumerated() {
            let newBoardState = boardState.deepCopy()
            newBoardState.makeLegalMove(x: move.x, y: move.y)
            values[index] = minimax(boardState: newBoardState, depth: searchDepth-1, bMaximising: false, alpha: Int.min, beta: Int.max)
        }
        dump(values)
        let highVal = values.max()
        let bestMoveIndex = values.firstIndex(of: highVal!)
        print(highVal!)
        return moves[bestMoveIndex!]
    }
    
    private func minimax(boardState: BoardState, depth: Int, bMaximising: Bool, alpha: Int, beta: Int) -> Int {
        // leaf node
        if boardState.gameOver() || depth == 0 {
            return evaluateBoard(boardState: boardState)
        }
        
        var alpha = alpha
        var beta = beta
        // Maximising Player
        if bMaximising {
            let moves = boardState.getLegalMoves()
            if moves.isEmpty {
                let newBoardState = boardState.deepCopy()
                newBoardState.changePlayer()
                return minimax(boardState: newBoardState, depth: depth-1, bMaximising: false, alpha: alpha, beta: beta)
            }
            var best = Int.min
            for move in moves {
                let newBoardState = boardState.deepCopy()
                newBoardState.makeLegalMove(x: move.x, y: move.y)
                let value = minimax(boardState: newBoardState, depth: depth-1, bMaximising: false, alpha: alpha, beta: beta)
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
                return minimax(boardState: newBoardState, depth: depth-1, bMaximising: true, alpha: alpha, beta: beta)
            }
            var best = Int.max
            for move in moves {
                let newBoardState = boardState.deepCopy()
                newBoardState.makeLegalMove(x: move.x, y: move.y)
                let value = minimax(boardState: newBoardState, depth: depth-1, bMaximising: true, alpha: alpha, beta: beta)
                best = min(best, value)
                beta = min(beta, best)
                if beta <= alpha {
                    break
                }
            }
            
            return best
        }
    }
    
    public func evaluateBoard(boardState: BoardState) -> Int {
        // evaluation board weight array
        let a = [120, -20, 20, 5, 5, 20, -20, 120]
        let b = [-20, -40, -5, -5, -5, -5, -40, -20]
        let c = [20, -5, 15, 3, 3, 15, -5, 20]
        let d = [5, -5, 3, 3, 3, 3, -5, 5]

        let values: [[Int]] = [a, b, c, d, d, c, b, a]
        
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
