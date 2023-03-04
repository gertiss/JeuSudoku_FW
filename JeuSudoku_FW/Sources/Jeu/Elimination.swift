//
//  Elimination.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 25/02/2023.
//

import Foundation

// MARK: - Elimination

/// Les primitives qui permettent de chercher les éliminations de cellules pour une valeur donnée


extension Puzzle {
    
    /// Calcul des cellules éliminées pour une valeur, directement et indirectement,
    /// dans toute la grille.
    /// On est définitivement certain que la valeur ne pourra pas être placée dans la région résultat.
    func cellulesEliminees(pour valeur: Int) -> Region {
        // On commence par éliminer d'office toutes les cellules résolues
        var region = cellulesResolues
        for contrainte in contraintesEliminantes(pour: valeur) {
            region = region.union(cellulesEliminees(par: contrainte, pour: valeur))
        }
        return region
    }
    
    /// Toutes les contraintes qui permettent d'éliminer la valeur.
    func contraintesEliminantes(pour valeur: Int) -> [Presence] {
        let res = contraintes.filter { contrainteEstEliminante($0, pour: valeur) }
        return res
    }
    
    func cellulesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        let externes = cellulesExternesEliminees(par: contrainte, pour: valeur)
        let internes = cellulesInternesEliminees(par: contrainte, pour: valeur)
        return externes.union(internes)
        
    }
    
    /// Indique si la contrainte éminine des cellules pour une valeur donnée ("émet des rayons")
    /// Les cellules éliminées ne pourront définitivement plus contenir la valeur.
    func contrainteEstEliminante(_ contrainte: Presence, pour valeur: Int) -> Bool {
        switch contrainte.type {
        case .singleton1:
            return contrainte.contient(valeur: valeur)
        case .paire2:
            return  contrainte.contient(valeur: valeur) && contrainte.estDansUnAlignement
        case .singleton2:
            return  !contrainte.contient(valeur: valeur)
        case .paire1:
            return contrainte.contient(valeur: valeur) && contrainte.estDansUnAlignement
        case .triplet3:
            return contrainte.contient(valeur: valeur) && contrainte.estDansUnAlignement
        }
    }
    
    /// Les cellules éliminées hors de la région de la contrainte
    /// toutes les cellules dans le champ de dépendance
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
        case .triplet3:
            return alignement.cellules.subtracting(contrainte.region)
        }
    }
    
    /// Les cellules éliminées à l'intérieur de la région de la contrainte.
    /// "Eliminée" veut dire "ne pouvant plus faire partie d'une nouvelle contrainte avec la valeur"
    func cellulesInternesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        switch contrainte.type {
        case .singleton1:
            return contrainte.region
        case .paire1:
            // Une paire 1 pourra être remplacée par une paire2
            // ou rendue obsolète par un singleton1
            return []
        case .paire2:
            // Seule une contrainte possédant une des valeurs de la paire2 peut intersecter une paire2.
            // Dans le cas d'intersection compatible, il y aura réduction.
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        case .singleton2:
            // Seule une contrainte possédant une des valeurs du singleton2 peut intersecter un singleton2.
            // Dans le cas d'intersection compatible, il y aura réduction.
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        case .triplet3:
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        }
        return []
    }
    
}
