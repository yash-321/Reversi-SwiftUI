//
//  Cell+Status.swift
//  Reversi
//
//  Created by Yash Sangha on 13/10/2022.
//

import Foundation

extension Cell {
    enum Status {
        case Empty
        case Potential(Piece)
        case Occupied
    }
}
