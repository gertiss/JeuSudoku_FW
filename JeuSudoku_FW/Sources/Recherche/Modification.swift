//
//  Puzzle_.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 21/02/2023.
//

import Foundation

/// Ces méthodes modifient le puzzle, c'est-à-dire fournissent un nouveau puzzle
extension Puzzle {
    
    /// Ajout d'une contrainte
    /// Vérifie sa validité si c'est un singleton (fatalError sinon)
    func plus(_ contrainte: Presence) -> Puzzle {
        if contrainte.type == .singleton1 {
            assert(estSingleton1Valide(contrainte))
        }
        let nouvellesContraintes = contraintes
            .ensemble.union([contrainte]) // Pour éviter les doublons
            .array.sorted() // Pour remettre sous forme canonique
        return Puzzle(contraintes: nouvellesContraintes)
    }
    
    /// Suppression d'une contrainte
    func moins(_ contrainte: Presence) -> Puzzle {
        let nouvellesContraintes = contraintes
            .ensemble.subtracting([contrainte])
            .array.sorted()
        return Puzzle(contraintes: nouvellesContraintes)
    }
    
}

extension Puzzle {
    
    /// Rend `presence` si c'est un singleton valide non encore présent, nil sinon.
    func nouveauSingletonValide(_ presence: Presence) -> Presence? {
        estNouveauSingletonValide(presence) ? presence : nil
    }
    
    /// Vérifie si `presence` est un  c'est un singleton valide non encore présent.
    func estNouveauSingletonValide(_ presence: Presence) -> Bool {
        !contraintes.contains(presence) && estSingleton1Valide(presence)
    }
}
