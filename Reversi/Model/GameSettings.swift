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
    
    @Published var searchDepth = 4
    
    var squareSize: CGFloat {
        UIScreen.main.bounds.width*0.9 / CGFloat(columns)
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
