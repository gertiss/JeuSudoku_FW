//
//  Bijection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 01/02/2023.
//

import Foundation

/// L'affirmation de l'existence d'une bijection entre un ensemble de cellules contenues dans une même zone et un ensemble de valeurs.
/// Avec cellules.count == valeurs.count
/// Mais on ne précise pas quelle bijection exactement. On ne précise pas la correspondance cellule par cellule.
public struct Bijection: Testable {
    
    public let cellules: Set<Cellule>
    public let valeurs: Set<Int>
    public let nom: String

    public init(_ cellules: Set<Cellule>, _ valeurs: Set<Int>) {
        assert(cellules.count == valeurs.count)
        self.cellules = cellules
        self.valeurs = valeurs
        let nomsCellules = cellules.map { $0.nom }
            .sorted()
            .joined()
        let nomsValeurs = valeurs.map { $0.description }
            .sorted()
            .joined()
        self.nom = "\(nomsCellules)_\(nomsValeurs)"
    }
    
    var cardinal: Int {
        cellules.count
    }
    
    public var description: String {
        "Bijection(\(cellules), \(valeurs))"
    }

}




