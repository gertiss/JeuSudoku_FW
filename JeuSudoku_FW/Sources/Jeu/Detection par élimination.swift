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

extension Puzzle {
    
    /// Une seule cellule restante après élimination
    func singleton1DetecteParElimination(pour valeur: Int, dans zone: any UneZone) -> Presence? {
        let eliminees = cellulesEliminees(pour: valeur)
        let restantes = zone.cellules.subtracting(eliminees)
        guard restantes.count == 1 else {
            return nil
        }
        let contrainte = Presence([valeur], dans: restantes)
        assert(contrainte.type == .singleton1)
        return contrainte
    }
    
    /// Deux seules cellules restantes alignées après élimination
    func paire1AligneeDetecteeParElimination(pour valeur: Int, dans zone: any UneZone) -> Presence? {
        let eliminees = cellulesEliminees(pour: valeur)
        let restantes = zone.cellules.subtracting(eliminees)
        guard restantes.count == 2 && restantes.estDansUnAlignement else {
            return nil
        }
        let contrainte = Presence([valeur], dans: restantes)
        assert(contrainte.type == .paire1)
        return contrainte
    }
}
