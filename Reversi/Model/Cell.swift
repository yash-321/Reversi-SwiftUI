//
//  Cell.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import Foundation
import SwiftUI

class Cell: ObservableObject {
    var row: Int
    var column: Int
    
    @Published var piece: Piece?
    
    @Published var status: Status
    
    init(row: Int, column: Int, piece: Piece?) {
        self.row = row
        self.column = column
        self.piece = piece
        self.status = .Empty
    }
    
    // Get the image associated to the status of the cell
    var image: Image {
        switch status {
        case .Empty:
            return Image("empty cell")
            
        case .Potential(let piece):
            if piece == .Black {
                return Image("black cell tinted")
            } else {
                return Image("white cell tinted")
            }
            
        case .Occupied:
            if piece == .Black {
                return Image("black cell")
            }
            else if piece == .White {
                return Image("white cell")
            }
        }
        return Image("")
    }
}
