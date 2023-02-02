//
//  Puzzle.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 02/02/2023.
//

import Foundation

/// Un Puzzle est défini par un ensemble de bijections et le problème à résoudre est de réduire cet ensemble à un ensemble équivalent de singletons.
public struct Puzzle {
    
    public let bijections: Set<Bijection>
    
    public init(bijections: Set<Bijection>) {
        self.bijections = bijections
    }
}

public extension Puzzle {
    
    /// Le code est une ligne de la banque de grilles
    /// publiée sur Sudoku Exchange "Puzzle Bank"
    /// https://sudokuexchange.com
    init(_ code: String) {
        let codage = CodagePuzzle(code)
        let chiffres = codage.chiffres
        var ensemble = Set<Bijection>()
        for indexLigne in 0...8 {
            for indexColonne in 0...8 {
                let chiffre = chiffres[indexLigne * 9 + indexColonne]
                if chiffre != 0 { ensemble.insert(Bijection([Cellule(indexLigne, indexColonne)], [chiffre]))}
            }
        }
        self = Self(bijections: ensemble)
    }
}

