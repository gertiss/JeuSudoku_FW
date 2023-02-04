//
//  Recherche par cellules.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 03/02/2023.
//

import Foundation


extension Puzzle {
    
    /// Découvrir toutes les nouvelles contraintes dont on donne le domaine.
    /// On se "focalise" sur ce domaine et on cherche ses valeurs.
    /// En fait il ne peut y  avoir que zéro ou une contrainte trouvée.
    func nouvellesContraintes(domaine: Domaine) -> Set<ExistenceBijection> {
        fatalError("à implémenter")
    }
}
