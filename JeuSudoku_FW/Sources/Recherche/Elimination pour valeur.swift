//
//  Elimination.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 25/02/2023.
//

import Foundation

// MARK: - Elimination pour valeur

/// Les primitives qui permettent de chercher les éliminations pour une valeur donnée.
/// Elles ont toutes un paramètre `valeur`
/// Elles effectuent une recherche globale, c'est-à-dire n'ont pas de paramètre `zone`.


extension Puzzle {
    
    /// Calcul des cellules éliminées pour une valeur, directement et indirectement,
    /// dans toute la grille.
    /// On est définitivement certain que la valeur ne pourra pas être placée dans la région résultat.
    /// Utilisé par `Coup_Paire2` et `Coup_Triplet3`
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
    /// Utilisé par `Coup_Paire2` et `Coup_Triplet3`
    func contraintesEliminantes(pour valeur: Int) -> [Presence] {
        let res = contraintes.filter { contrainteEstEliminante($0, pour: valeur) }
        return res
    }
    
    
    /// Une contrainte peut éliminer des cellules à l'intérieur d'elles-même aussi bien qu'à l'extérieur.
    /// Cela dépend du type de la contrainte et de sa relation avec la valeur.
    /// Utilisé par `Coup_Paire2` et `Coup_Triplet3`
    func cellulesEliminees(par contrainte: Presence, pour valeur: Int) -> Region {
        let externes = cellulesExternesEliminees(par: contrainte, pour: valeur)
        let internes = cellulesInternesEliminees(par: contrainte, pour: valeur)
        return externes.union(internes)
        
    }
    
    /// Indique si la contrainte élinine des cellules pour une valeur donnée ("émet des rayons")
    /// Les cellules éliminées ne pourront définitivement plus contenir la valeur.
    /// Utilisé par `Coup_Paire2` et `Coup_Triplet3`
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
    
    /// Utilisé par tous les types de coups
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
    
    /// Les cellules éliminées hors de la région de la contrainte.
    /// toutes les cellules dans le champ de dépendance.
    /// Utilisé par tous les types de coups.
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
    /// Utilisé par `Coup_Paire2` et `Coup_Triplet3`
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
    
    /// le nombre de `cibles` éliminées par la `contrainte`
    func pouvoirEliminateur(singleton: Presence, cibles: Region) -> Int {
        assert(singleton.type == .singleton1)
        let eliminatrice = singleton.uniqueCellule
        var pouvoir = 0
        for cible in cibles {
            if eliminatrice.dependantes.contains(cible) {
                pouvoir += 1
            }
        }
        return pouvoir
    }
}

