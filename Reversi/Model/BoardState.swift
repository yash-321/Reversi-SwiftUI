//
//  BoardState.swift
//  Reversi
//
//  Created by Yash Sangha on 18/10/2022.
//

import Foundation
import CoreML

class BoardState {
    private var settings: GameSettings
    private var board: [[Cell]]
    public var turn: Piece 
    
    init(settings: GameSettings, turn: Piece) {
        self.settings = settings
        self.board = Self.generateBoard(from: settings)
        self.turn = turn
    }
    
    public func getMLArrayBoard() -> MLMultiArray {
        guard let multiArray = try? MLMultiArray(
            shape: [1, 1, 8, 8], dataType: .float32) else {
            fatalError("Error initialising MLMultiArray")
        }
        
        for i in 0..<settings.rows {
            for j in 0..<settings.columns {
                multiArray[[0,0,i,j] as [NSNumber]] = Float(board[i][j].value) as NSNumber
            }
        }
        
        return multiArray
    }
    
    public func changePlayer() {
        turn = (!turn)!
    }
    
    public func setPlayer(piece: Piece) {
        turn = piece
    }
    
    public func deepCopy() -> BoardState {
        let newBoardState = BoardState(settings: settings, turn: turn)
        
        for i in 0..<settings.rows {
            for j in 0..<settings.columns {
                if getContents(x: i, y: j) != nil {
                    newBoardState.setPiece(x: i, y: j, piece: getContents(x: i, y: j)!)
                }
            }
        }
        return newBoardState
    }
    
    public func gameOver() -> Bool {
        
        var over = false;
        if getLegalMoves().isEmpty {
            changePlayer()              // change player temporarily
            if getLegalMoves().isEmpty {
                over = true
            }
            changePlayer()               // change colour back
        }
        return over;
    }
    
    public func getCell(x: Int, y: Int) -> Cell {
        return board[x][y]
    }
    
    public func getContents(x: Int, y: Int) -> Piece? {
        return board[x][y].piece
    }
    
    public func setPiece(x: Int, y: Int, piece: Piece) {
        let cell = board[x][y]
        cell.piece = piece
    }
    
    public func getLegalMoves() -> [Move] {
        // Very simple method
        var moves = [Move]()
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                if(checkLegalMove(x: i, y: j)) {
                    moves.append(Move(x: i, y: j))
                }
            }
        }
        return moves
    }
    
    public func makeLegalMove(x: Int, y: Int){
        
        var a: Int
            
        // Current square
        // setContents(x, y, colour);
        
        // Squares to left
        a = checkLeft(x: x, y: y)
        if(a != -1) {
            for i in a...x {
                setPiece(x: i, y: y, piece: turn)
            }
        }
        
        // Squares to right
        a = checkRight(x: x, y: y)
        if(a != -1) {
            for i in x...a {
                setPiece(x: i, y: y, piece: turn)
            }
        }
        
        // Squares above
        a = checkUp(x: x, y: y)
        if(a != -1) {
            for j in a...y {
                setPiece(x: x, y: j, piece: turn)
            }
        }

        
        // Squares below
        a = checkDown(x: x, y: y)
        if(a != -1) {
            for j in y...a {
                setPiece(x: x, y: j, piece: turn)
            }
        }
        
        
        // Squares to above left
        a = checkUpLeft(x: x, y: y)
        if(a != -1) {
            for i in 0...x-a {
                setPiece(x: x-i, y: y-i, piece: turn)
            }
        }

        // Squares above right
        a = checkUpRight(x: x, y: y)
        if(a != -1) {
            for i in 0...a-x {
                setPiece(x: x+i, y: y-i, piece: turn)
            }
        }
      
            
        // Squares to below left
        a = checkDownLeft(x: x, y: y)
        if(a != -1) {
            for i in 0...x-a {
                setPiece(x: x-i, y: y+i, piece: turn)
            }
        }

        // Squares below right
        a = checkDownRight(x: x, y: y)
        if(a != -1) {
            for i in 0...a-x {
                setPiece(x: x+i, y: y+i, piece: turn)
            }
        }
        
        changePlayer()               // Change player
        
    }
    
    public func checkLegalMove(x: Int, y: Int) -> Bool {
        return (board[x][y].piece == nil) && ((checkLeft(x: x, y: y) != -1) ||
                                              (checkRight(x: x, y: y) != -1) ||
                                              (checkUp(x: x, y: y) != -1) ||
                                              (checkDown(x: x, y: y) != -1) ||
                                              (checkUpLeft(x: x, y: y) != -1) ||
                                              (checkUpRight(x: x, y: y) != -1) ||
                                              (checkDownLeft(x: x, y: y) != -1) ||
                                              (checkDownRight(x: x, y: y) != -1))
    }
    
    private func checkLeft(x: Int, y: Int) -> Int {
        var i = x-1
        while((i > 0) && (board[i][y].piece == !turn)) { //check almost to start
            i -= 1
        }
        
        if((i < x-1) && board[i][y].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkRight(x: Int, y: Int) -> Int {
        var i = x+1
        while((i < board.count-1) && (board[i][y].piece == !turn)) { //check almost to start
            i += 1
        }
        
        if((i > x+1) && board[i][y].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkUp(x: Int, y: Int) -> Int {
        var i = y-1
        while((i > 0) && (board[x][i].piece == !turn)) { //check almost to start
            i -= 1
        }
        
        if((i < y-1) && board[x][i].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkDown(x: Int, y: Int) -> Int {
        var i = y+1
        while((i < board[x].count-1) && (board[x][i].piece == !turn)) { //check almost to start
            i += 1
        }
        
        if((i > y+1) && board[x][i].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkUpLeft(x: Int, y: Int) -> Int {
       var i = x-1
       var j = y-1
    
       while((i > 0) && (j > 0) && (board[i][j].piece == !turn)){  //check almost to start
           i -= 1
           j -= 1
       }
        
        if((i < x-1) && board[i][j].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkUpRight(x: Int, y: Int) -> Int {
       var i = x+1
       var j = y-1
    
       while((i < board.count-1) && (j > 0) && (board[i][j].piece == !turn)){  //check almost to start
           i += 1
           j -= 1
       }
        
        if((i > x+1) && board[i][j].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkDownLeft(x: Int, y: Int) -> Int {
       var i = x-1
       var j = y+1
    
       while((i > 0) && (j < board[x].count-1) && (board[i][j].piece == !turn)){  //check almost to start
           i -= 1
           j += 1
       }
        
        if((i < x-1) && board[i][j].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    private func checkDownRight(x: Int, y: Int) -> Int {
       var i = x+1
       var j = y+1
    
        while((i < board.count-1) && (j < board[x].count-1) && (board[i][j].piece == !turn)){  //check almost to start
           i += 1
           j += 1
       }
        
        if((i > x+1) && board[i][j].piece == turn) {
            return i
        } else {
            return -1
        }
    }
    
    public func result() -> [Piece:Int] {
            
        var result = [Piece:Int]()
        result[.Black] = 0
        result[.White] = 0
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                if board[i][j].piece != nil {
                    result[board[i][j].piece!]! += 1
                }
            }
        }
        return result
    }
    
    
    
    private static func generateBoard(from settings: GameSettings) -> [[Cell]] {
        var newBoard = [[Cell]]()

        // Create our board with cells
        for row in 0..<settings.rows {
            var column = [Cell]()
            for col in 0..<settings.columns {
                column.append(Cell(row: row, column: col, piece: nil))
            }
            newBoard.append(column)
        }

        // Place initial pieces
        let half = settings.columns/2
        newBoard[half][half].piece = .Black
        newBoard[half-1][half-1].piece = .Black
        newBoard[half-1][half].piece = .White
        newBoard[half][half-1].piece = .White

        return newBoard
    }
}
