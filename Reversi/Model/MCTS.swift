//
//  MCTS.swift
//  Reversi
//
//  Created by Yash Sangha on 23/02/2023.
//

import Foundation

struct StateActionPair: Hashable {
    let state: String
    let action: Int
}

class MCTS {
    private let settings: GameSettings
    private let nnet: AlphaZero
    private let cpuct = 1
    private var Qsa: [StateActionPair: Float] = [:]
    private var Nsa: [StateActionPair: Int] = [:]
    private var Ns: [String: Int] = [:]
    private var Ps: [String: [Float]] = [:]
    private var Es: [String: Float] = [:]
    private var Vs: [String: [Float]] = [:]
    
    init(settings: GameSettings, nnet: AlphaZero) {
        self.settings = settings
        self.nnet = nnet
    }
    
    func getActionProb(canonicalBoard: BoardState) -> [Float] {
        var v = Float(0)
        for _ in 0..<settings.mctsSims {
            let board = canonicalBoard.deepCopy()
            v = search(canonicalBoard: board)
        }
        
        let s = canonicalBoard.stringRepresentation()
        let counts = (0..<settings.actionSize).map { Nsa[StateActionPair(state: s, action: $0)] ?? 0 }
        
        print(counts)
        print(v)

        let bestAs = counts.indices.filter { counts[$0] == counts.max() }
        let bestA = bestAs.randomElement()!
        var probs = [Float](repeating: 0, count: counts.count)
        probs[bestA] = 1
        return probs
    }
    
    private func search(canonicalBoard: BoardState) -> Float {
        let s = canonicalBoard.stringRepresentation()
        
        if Es[s] == nil {
            Es[s] = Float(canonicalBoard.getGameEnded(player: 1))
        }
        if Es[s] != 0 {
            // terminal node
            return -Es[s]!
        }
        
        if Ps[s] == nil {
            // leaf node
            let (p, v) = nnet.predict(boardState: canonicalBoard)
            let valids = nnet.movesToOneHot(moves: canonicalBoard.getLegalMoves(), settings: settings)
            Ps[s] = zip(p, valids).map { $0 * $1 } // masking invalid moves
            let sum_Ps_s = Ps[s]!.reduce(0, +)
            if sum_Ps_s > 0 {
                Ps[s] = Ps[s]!.map { $0 / sum_Ps_s } // renormalize
            } else {
                // if all valid moves were masked make all valid moves equally probable
                print("All valid moves were masked, doing a workaround.")
                Ps[s] = zip(Ps[s]!, valids).map { $0 + $1 }
                let sum_Ps_s2 = Ps[s]!.reduce(0, +)
                Ps[s] = Ps[s]!.map { $0 / sum_Ps_s2 }
            }
            
            Vs[s] = valids
            Ns[s] = 0
            return -v
        }
        
        let valids = Vs[s]
        var cur_best = -Float.greatestFiniteMagnitude
        var best_act = -1
        
        // Pick action with highest UCB
        for a in (0..<settings.actionSize) {
            if valids![a] != 0.0 {
                var u: Float
                if Qsa[StateActionPair(state: s, action: a)] != nil {
                    let Qval = Qsa[StateActionPair(state: s, action: a)]!
                    let p = Float(cpuct) * Ps[s]![a] * sqrt(Float(Ns[s]!))
                    let n = (1 + Nsa[StateActionPair(state: s, action: a)]!)
                    u = Qval + (p/Float(n))
                } else {
                    u = Float(cpuct) * Ps[s]![a] * sqrt(Float(Ns[s]!) + Float.greatestFiniteMagnitude)
                }
                
                if u > cur_best {
                    cur_best = u
                    best_act = a
                }
            }
        }
        
        let a = best_act
        let next_board = canonicalBoard.deepCopy()
        next_board.makeLegalMove(x: Int(best_act/settings.rows), y: best_act%settings.rows)
        
        let v = search(canonicalBoard: next_board)
        
        if Qsa[StateActionPair(state: s, action: a)] != nil {
            Qsa[StateActionPair(state: s, action: a)] = (Float(Nsa[StateActionPair(state: s, action: a)]!) * Qsa[StateActionPair(state: s, action: a)]! + v) / Float((Nsa[StateActionPair(state: s, action: a)]! + 1))
            Nsa[StateActionPair(state: s, action: a)]! += 1
        } else {
            Qsa[StateActionPair(state: s, action: a)] = v
            Nsa[StateActionPair(state: s, action: a)] = 1
        }
        
        Ns[s]! += 1
        return -v
    }
}

       

