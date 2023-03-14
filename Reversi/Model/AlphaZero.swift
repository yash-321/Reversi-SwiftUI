//
//  AlphaZero.swift
//  Reversi
//
//  Created by Yash Sangha on 23/02/2023.
//

import Foundation
import CoreML


class AlphaZero: MoveChooser{
    var model: reversiAI?
    
    init() {
        do {
            self.model = try reversiAI(configuration: MLModelConfiguration())
        } catch {
            print("Error loading model")
        }
    }
    
    func chooseMove(boardState: BoardState, settings: GameSettings) -> Move? {
        let moves = boardState.getLegalMoves()
        if moves.isEmpty {
            return nil
        }
        let state = boardState.getMLArrayBoard()
        guard let prediction = try? model!.prediction(x_1: state) else {
            fatalError("Prediction failed.")
        }
        
        let policyOut = prediction.var_159
        let value = prediction.var_160
        
        print(value)
        
        let count = policyOut.count
        let pointer = UnsafeMutablePointer<Float32>(OpaquePointer(policyOut.dataPointer))
        let buffer = UnsafeBufferPointer(start: pointer, count: count)
        let policy = softmax(Array(buffer))
        
        print(policy)
        
        
        let validMoves = movesToOneHot(moves: moves, settings: settings)
        
        print(validMoves)
        
        let maskedPolicy = zip(policy, validMoves).map{ $0 * $1 }
        
        print(maskedPolicy)
        
        let maxIndex = policy.firstIndex(of: maskedPolicy.max()!)
        
        print(maxIndex!)
        
        let bestMove = Move(x: Int(maxIndex!/settings.rows), y: maxIndex!%settings.rows)
        
        print(bestMove)
        
        return bestMove
    }
    
    
    private func movesToOneHot(moves: [Move], settings: GameSettings) -> [Float] {
        var oneHot = [Float](repeating: 0.0, count: 65)

        for move in moves {
            oneHot[move.x*settings.rows+move.y] = 1.0
        }
        
        return oneHot
    }
    
    func softmax(_ array: [Float32]) -> [Float32] {
        let max = array.max() ?? 0
        let expArray = array.map { exp($0 - max) }
        let sum = expArray.reduce(0, +)
        return expArray.map { $0 / sum }
    }

    
}



