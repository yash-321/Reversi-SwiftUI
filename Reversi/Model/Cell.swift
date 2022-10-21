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
    
    init(row: Int, column: Int, piece: Piece?) {
        self.row = row
        self.column = column
        self.piece = piece
    }
    
    // Get the image associated to the status of the cell
    var image: Image {
        if piece == .Black {
            return Image("black circle")
        }
        else if piece == .White {
            return Image("white circle")
        } else {
            return Image("")
        }
    }
}
