//
//  Elimination.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 25/02/2023.
//

import Foundation

// MARK: - Elimination

/// Représente le fait suivant :
/// les `eliminees`sont exactement toutes les cellules éliminées globalement pour la `valeur`
/// les  éliminations sont causées par les`eliminatrices` (seulement celles qui sont nécessaires)
struct EliminationDirecteRegion {
    let valeur: Int
    let eliminees: Region
    let eliminatrices: [Presence]
}

/// La cellule `eliminee` est éliminée par la contrainte `eliminatrice` pour la `valeur`
struct EliminationDirecteCellule {
    let valeur: Int
    let eliminee: Cellule
    let eliminatrice: Presence
}


/// Les primitives qui permettent de chercher les éliminations de cellules pour une valeur donnée


extension Puzzle {
    
    /// Calcul des cellules éliminées pour une valeur, directement et indirectement,
    /// dans toute la grille.
    /// On est définitivement certain que la valeur ne pourra pas être placée dans la région résultat.
    func cellulesEliminees(pour valeur: Int) -> Region {
        // On commence par éliminer d'office toutes les cellules résolues globalement
        var region = cellulesResolues
        for contrainte in contraintesEliminantes(pour: valeur) {
            region = region.union(cellulesEliminees(par: contrainte, pour: valeur))
        }
        _ = "à compléter. Retourner elimination au lieu de region. Filtrer les eliminatrices utiles"
        return region
    }
    
    /// Toutes les contraintes qui permettent d'éliminer la valeur.
    func contraintesEliminantes(pour valeur: Int) -> [Presence] {
        let res = contraintes.filter { contrainteEstEliminante($0, pour: valeur) }
        return res
    }
    
    
    /// Une contrainte peut éliminer des cellules à l'intérieur d'elles-même aussi bien qu'à l'extérieur.
    /// Cela dépend du type de la contrainte et de sa relation avec la valeur.
    func cellulesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        let externes = cellulesExternesEliminees(par: contrainte, pour: valeur)
        let internes = cellulesInternesEliminees(par: contrainte, pour: valeur)
        return externes.union(internes)
        
    }
    
    /// Indique si la contrainte élinine des cellules pour une valeur donnée ("émet des rayons")
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
    
    func estEliminanteDirectement(_ contrainte: Presence) -> Bool {
        switch contrainte.type {
        case .singleton1:
            return true
        case .singleton2:
            return false
        case .paire1:
            return contrainte.estDansUnAlignement
        case .paire2:
            return contrainte.estDansUnAlignement
        case .triplet3:
            return contrainte.estDansUnAlignement
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
            return []
        case .paire2:
            if !contrainte.contient(valeur: valeur) {
                return contrainte.region
            }
        case .singleton2:
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
    
    /// Une paire1 est utile pour une élimination indirecte si elle élimine au moins une cellule vide
    /// et non déjà éliminée directement
    func paire1EstUtile(_ paire1: Presence, cellulesElimineesDirectement : Region) -> Bool {
        assert(paire1.type == .paire1)
        let valeur = paire1.valeurs.uniqueElement
        let eliminees = cellulesExternesEliminees(par: paire1, pour: valeur)
        let utiles = eliminees.subtracting(cellulesElimineesDirectement)
        return !utiles.isEmpty
    }
    
    func estEliminatrice(_ contrainte: Presence, eliminee: Cellule, valeur: Int) -> Bool {
        cellulesEliminees(par: contrainte, pour: valeur).contains(eliminee)
    }
    
}
