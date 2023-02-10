//
//  Exemple.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 03/02/2023.
//

import Foundation


/// Equivalent à "dans tel puzzle, on a effectué telle recherche qui a donné tels résultats"
public struct ExempleResolu {
    
    public let puzzle: Puzzle
    public let rapport: RapportDeRecherche
    
    public init(puzzle: Puzzle, rapport: RapportDeRecherche) {
        self.puzzle = puzzle
        self.rapport = rapport
    }
    
}

public extension ExempleResolu {
    
    /// La contrainte qui a été découverte : certaines valeurs doivent être obligatoirement présentes dans une certaine région.
    var contrainte:  PresenceValeurs {
        rapport.decouverte.contrainte
    }
    
    var region: Set<Cellule> {
        contrainte.region
    }
    
    var valeurs: Set<Int> {
        contrainte.valeurs
    }

}

