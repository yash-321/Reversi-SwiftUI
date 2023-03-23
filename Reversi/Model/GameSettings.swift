//
//  GameSettings.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import Foundation
import SwiftUI

class GameSettings: ObservableObject {
    // Board size
    @Published var rows = 8
    @Published var columns = 8
    @Published var actionSize = 65
    
    @Published var searchDepth = 4
    
    @Published var mctsSims = 25
    
    @Published var player1: MoveChooser?
    @Published var player2: MoveChooser
    
    var squareSize: CGFloat {
        UIScreen.main.bounds.width*0.9 / CGFloat(columns)
    }
    
    init(player1: PlayerType = .human, player2: PlayerType) {
        switch(player1){
        case .alphaZero:
            self.player1 = AlphaZero()
            
        case .minimax:
            self.player1 = Minimax()
            
        default:
            self.player1 = nil
        }
        switch(player2){
        case .alphaZero:
            self.player2 = AlphaZero()
            
        case .minimax:
            self.player2 = Minimax()
            
        default:
            self.player2 = AlphaZero()
        }
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
