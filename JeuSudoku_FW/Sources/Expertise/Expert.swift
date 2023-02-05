//
//  Expert.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 04/02/2023.
//

import Foundation

    
/// Un expert en résolution de sudoku pour trouver de nouvelles contraintes sur un Puzzle
/// Il possède deux stratégies de résolution, qu'il essaye dans l'ordre :
/// 1. chercher directement dans Self.baseExemples
/// 2. appliquer des règles
public struct Expert {
    
    public let puzzle: Puzzle
    
    public init(_ puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    static public var ensembleExemples: Set<ExempleResolu> = []
    
    /// Version indexée de ensembleExemples
    static var dicoExemples: [Puzzle: ExempleResolu] {
        var dico = [Puzzle: ExempleResolu]()
        ensembleExemples.forEach { dico[$0.puzzle] = $0 }
        return dico
    }
    
    static func ajouterExemple(_ exemple: ExempleResolu) {
        // La base ne doit contenir qu'un seul exemple au plus pour chaque puzzle
        if let exemplePresent = dicoExemples[exemple.puzzle] {
            ensembleExemples.remove(exemplePresent)
        }
        ensembleExemples.insert(exemple)
    }
}

public extension Expert {
    
    var nouvellesContraintes: RapportDeRecherche {
        // recherche dans la base d'abord
        if let exemple = Self.dicoExemples[puzzle] {
            return exemple.rapport
        }
        // recherche avec des règles : à implémenter
        // par défaut pour le bootstrap
        return RapportDeRecherche(decouvertes: [])
    }
        
}
