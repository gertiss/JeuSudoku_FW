//
//  PresenceValeur.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 09/02/2023.
//

import Foundation

public struct PresenceValeur: UneContrainte {
    public var type: TypeContrainte { .presenceValeur }
    public var puzzle: Puzzle
    
    public let valeur: Int
    
    public init(_ valeur: Int, dans puzzle: Puzzle) {
        self.valeur  = valeur
        self.puzzle = puzzle
    }
}
