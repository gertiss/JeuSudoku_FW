//
//  Detection.swift
//  JeuSudoku_FW
//
//  Created by Gérard Tisseau on 26/02/2023.
//

import Foundation

// MARK: - Détection de contraintes par élimination

/// On essaye de trouver des contraintes contenant une valeur dans une zone,
/// après élimination des cellules pour cette valeur.

public extension Puzzle {
    
    /// Une seule cellule restante après élimination directe
    func singleton1DetecteParEliminationDirecte(pour valeur: Int, dans region: Region) -> Presence? {
        let eliminees = cellulesEliminees(pour: valeur)
        let restantes = region.subtracting(eliminees)
        assert(!restantes.contains { celluleEstResolue($0) })
        guard restantes.count == 1 else {
            return nil
        }
        let contrainte = Presence([valeur], dans: restantes)
        assert(contrainte.type == .singleton1)
        assert(!contraintes.contains(contrainte))
        return contrainte
    }
 
    /// Une seule cellule restante après élimination indirecte
    func singleton1DetecteParEliminationIndirecte(pour valeur: Int, dans region: Region) -> Presence? {
        let paires1 = paires1AligneesDetecteesParElimination(pour: valeur).ensemble
        // On fait la recherche dans un puzzle temporaire
        // avec les paires1
        let nouvellesContraintes = (contraintes + paires1).ensemble.array.sorted()
        let nouveauPuzzle = Puzzle(contraintes: nouvellesContraintes)
        if let singleton1 = nouveauPuzzle.singleton1DetecteParEliminationDirecte(pour: valeur, dans: region) {
            return singleton1
        }
        return nil
    }

    
    /// Deux seules cellules restantes alignées après élimination
    /// Attention: tant qu'une paire1 n'a pas été réduite, elle sera retrouvée à chaque fois.
    /// Donc on ne la "détecte" que la première fois.
    func paire1AligneeDetecteeParElimination(pour valeur: Int, dans zone: any UneZone) -> Presence? {
        let eliminees = cellulesEliminees(pour: valeur)
        let restantes = zone.cellules.subtracting(eliminees)
        assert(!restantes.contains { celluleEstResolue($0) })
       guard restantes.count == 2 && restantes.estIncluseDansUnAlignement else {
            return nil
        }
        let contrainte = Presence([valeur], dans: restantes)
        assert(contrainte.type == .paire1)
        if contraintes.contains(contrainte) {
            return nil // déjà présente
        }
        return contrainte
    }
    
    func paires1AligneesDetecteesParElimination(pour valeur: Int) -> [Presence] {
        var liste = [Presence]()
        for zone in Grille.zones {
            if let paire = paire1AligneeDetecteeParElimination(pour: valeur, dans: zone) {
                liste.append(paire)
            }
        }
        return liste.ensemble.array.sorted()
    }
}
