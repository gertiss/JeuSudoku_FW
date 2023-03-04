//
//  Verification.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 27/02/2023.
//

import Foundation

public extension Puzzle {
    
    /// Vérification avec la solution connue.
    /// solution est un puzzle entièrement réduit à des singleton1, entièrement résolu.
    /// La contrainte doit avoir les valeurs qui sont dans la solution.
    func contrainteEstCompatible(_ contrainte: Presence, solution: Puzzle) -> Bool {
        let valeursDansSolution = contrainte.region
            .map { cellule in
                let contraintesSolution = solution.contraintes(cellule: cellule).ensemble
                guard let singleton = contraintesSolution.uniqueValeur else {
                    fatalError()
                }
                return singleton.valeurs.uniqueElement
            }
        return contrainte.valeurs.isSuperset(of: valeursDansSolution.ensemble)  
    }
}
