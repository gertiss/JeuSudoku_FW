//
//  Elimination.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 25/02/2023.
//

import Foundation

// MARK: - Elimination


extension Puzzle {
    
    /// Calcul des cellules éliminées pour une valeur, directement et indirectement,
    /// dans toute la grille.
    /// On est définitivement certain que la valeur ne pourra pas être placée dans la région résultat.
    func cellulesEliminees(pour valeur: Int) -> Region {
        var region = Region()
        for contrainte in contraintesEliminantes(pour: valeur) {
            region = region.union(cellulesEliminees(par: contrainte, pour: valeur))
        }
        return region
    }
    
    /// Toutes les contraintes qui permettent d'éliminer la valeur.
    func contraintesEliminantes(pour valeur: Int) -> [Presence] {
        contraintes.filter { contrainteEstEliminante($0, pour: valeur) }
    }
    
    func cellulesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        cellulesExternesEliminees(par: contrainte, pour: valeur)
            .union(cellulesInternesEliminees(par: contrainte, pour: valeur))
    }
    
    func contrainteEstEliminante(_ contrainte: Presence, pour valeur: Int) -> Bool {
        switch contrainte.type {
        case .singleton1:
            return contrainte.contient(valeur: valeur)
        case .paire2:
            return  !contrainte.contient(valeur: valeur) || contrainte.estDansUnAlignement
        case .singleton2:
            return  !contrainte.contient(valeur: valeur)
        case .paire1:
            return contrainte.contient(valeur: valeur) && contrainte.estDansUnAlignement
        }
    }
    
    /// Les cellules éliminées hors de la région de la contrainte
    func cellulesExternesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        guard let alignement = contrainte.alignement else {
            return []
        }
        switch contrainte.type {
        case .singleton1:
            let cellule = contrainte.region.uniqueElement
            return cellule.ligne.cellules
                .union(cellule.colonne.cellules)
                .union(cellule.carre.cellules)
                .subtracting(contrainte.region)
        case .paire1:
            return alignement.cellules.subtracting(contrainte.region)
        case .paire2:
            return alignement.cellules.subtracting(contrainte.region)
        case .singleton2:
            return []
        }
    }
    
    /// Les cellules éliminées dans la région de la contrainte
    func cellulesInternesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        switch contrainte.type {
        case .singleton1:
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        case .paire1:
            return []
        case .paire2:
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        case .singleton2:
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        }
        return []
    }
    
}
