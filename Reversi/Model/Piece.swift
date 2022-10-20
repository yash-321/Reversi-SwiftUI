//
//  Piece.swift
//  Reversi
//
//  Created by Yash Sangha on 12/10/2022.
//

import Foundation

enum Piece {
    case Black, White
}

prefix func !(a: Piece?) -> Piece? {
    if a != nil {
        return a == .Black ? .White : .Black
    }
    return nil
}
